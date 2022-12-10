Shader "ShaderFun/Water/Acceleration" {
	Properties {
		[MainTexture] WaterHeight("Water Height", 2D) = "gray" {}
		WaterSize("Water Size", Vector) = (512, 512, 0, 0)
		TerrainHeight("Terrain Height", 2D) = "gray" {}
		TerrainSize("Terrain Size", Vector) = (512, 512, 0, 0)
		ds("Sampling Distance", Float) = .05
		ca("Amplifying Coefficient", Float) = 1
		depthLimit("Depth Limit", Range(0, .1)) = 1
	}

	SubShader {
		Tags { "RenderType" = "Opaque" }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "../Field/field.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D WaterHeight;
			float4 WaterSize;
			sampler2D TerrainHeight;
			float4 TerrainSize;
			float ds;
			float ca;
			float depthLimit;

			float2 XYToUv(float2 xy) {
				return xy / WaterSize.xy;
			}
			float2 UvToXy(float2 uv) {
				return uv * WaterSize.xy;
			}
			float HeightAt(sampler2D tex, float2 xy) {
				return DecodeField(tex2D(tex, XYToUv(xy)).rgb);
			}

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float Flux(float targetWaterDepth, float selfWaterDepth, float heightDeltaTo) {
				if(targetWaterDepth < depthLimit) {
					if(selfWaterDepth < depthLimit)
						return 0;
					if(heightDeltaTo > 0)
						return 0;
					return heightDeltaTo;
				}
				if(selfWaterDepth < depthLimit) {
					if(heightDeltaTo > 0)
						return heightDeltaTo;
					return 0;
				}
				return heightDeltaTo;
			}

			static const int samplingCount = 7;
			float4 frag(v2f i) : SV_Target{
				float2 xy = UvToXy(i.uv);

				float flux = 0;
				float selfWaterHeight = HeightAt(WaterHeight, xy);
				float selfTerrainHeight = HeightAt(TerrainHeight, xy);
				float selfWaterDepth = selfWaterHeight - selfTerrainHeight;
				for(int i = 0; i < samplingCount; ++i) {
					float angle = TAU * i / samplingCount;
					float c = cos(angle), s = sin(angle);
					float2x2 t = float2x2(c, -s, s, c);
					float2 samplingPosition = xy + ds * UvToXy(mul(float2(1, 0), t));
					
					float waterHeight = HeightAt(WaterHeight, samplingPosition);
					float terrainHeight = HeightAt(TerrainHeight, samplingPosition);
					float waterDepth = waterHeight - terrainHeight;
					float heightDelta = waterHeight - selfWaterHeight;

					flux += Flux(waterDepth, selfWaterDepth, heightDelta);
				}
				flux *= ca / samplingCount / ds;

				return EncodeField(flux);
			}
			ENDCG
		}
	}
}