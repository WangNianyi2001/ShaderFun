Shader "ShaderFun/Hatch" {
	Properties {
		_MainTex("Hatch texture", 2D) = "white" {}
		_Hardness("Hardness", Range(0, 1)) = 0
		_BaseColor("Base color", Color) = (1, 1, 1)
		_StrokeColor("Stroke color", Color) = (0, 0, 0)
		[ShowAsVector2] _LuminanceRange("Luminance range", Vector) = (0, 1, 0, 0)
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float luminance : FLOAT;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Hardness;
			float4 _BaseColor;
			float4 _StrokeColor;
			float2 _LuminanceRange;

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				// Compute diffusion
				fixed3 worldLightDir = normalize(WorldSpaceLightDir(v.vertex));
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.luminance = max(0, dot(worldLightDir, worldNormal));

				return o;
			}

			float4 frag(v2f i): SV_Target {
				float luminance = i.luminance;
				luminance = clamp(luminance, _LuminanceRange.x, _LuminanceRange.y);

				// Horizontal hatch
				float hatch = tex2D(_MainTex, i.uv).r;

				// Vertical hatch
				float2 tUv;
				tUv.x = i.uv.y + .618;	// Prevent diagonal symmetric
				tUv.y = i.uv.x;
				hatch = 1 - hatch;
				_Hardness *= .5;
				hatch *= smoothstep(_Hardness, 1 - _Hardness, luminance) * tex2D(_MainTex, tUv).r;
				hatch = 1 - hatch;

				hatch = luminance > hatch ? 0 : hatch;

				return lerp(_BaseColor, _StrokeColor, hatch);
			}
			ENDCG
		}
	}
}
