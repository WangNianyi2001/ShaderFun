Shader "ShaderFun/Water/Utt" {
	Properties {
		[MainTexture] Height("Height Field", 2D) = "gray" {}
		[ShowAsVector2] resolution("Resolution", Vector) = (512, 512, 0, 0)
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

			sampler2D Height;
			float4 resolution;

			float2 WorldToUv(float2 world) {
				return world / resolution.xy;
			}
			float2 UvToWorld(float2 uv) {
				return uv * resolution.xy;
			}
			float HeightAt(float2 world) {
				return DecodeField(tex2D(Height, WorldToUv(world)));
			}

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target{
				float2 world = UvToWorld(i.uv);
				float res = 0;
				res += HeightAt(world + float2(+1, 0));
				res += HeightAt(world + float2(-1, 0));
				res += HeightAt(world + float2(0, +1));
				res += HeightAt(world + float2(0, -1));
				res /= 4;
				res -= HeightAt(world);
				return EncodeField(res);
			}
			ENDCG
		}
	}
}