Shader "ShaderFun/TorusTwist" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_Progress("Progress", Range(0, 1)) = 0.0
	}

	SubShader {
		Tags { "RenderType" = "Opaque" }
		Cull Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Progress;

			static const float TAU = atan(1) * 8;
			static const float SIZE = 10;

			float2x2 Rotation(float t) {
				float c = cos(t), s = sin(t);
				return float2x2(c, -s, s, c);
			}

			float3 Torus(float2 uv) {
				uv *= TAU / SIZE;
				float3 pos = float3(cos(uv.x), sin(uv.x), 0);
				pos.x += 2;
				pos.xz = mul(pos.xz, Rotation(uv.y));
				return pos;
			}

			float3 Transform(float2 uv) {
				float3 a = Torus(uv), b = Torus(mul(uv, Rotation(_Progress * TAU / 4)));
				b.yz = mul(b.yz, Rotation(TAU / 4));
				return a * (1 - _Progress) + b * _Progress;
			}

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(float4(Transform(v.vertex.xz), 1));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				float4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
