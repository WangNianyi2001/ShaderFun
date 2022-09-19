Shader "ShaderFun/GaussianBlur" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_Radius("Radius", Range(0, 1)) = 0
	}

	SubShader{
		Tags { "RenderType" = "Opaque" }

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

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _Radius;

			// Normal distribution integrated from -1 to 1.
			static const float A = 1.49365;
			static const float TAU = atan(1) * 8;

			float NormDist(float x) {
				return exp(-pow(x, 2));
			}

			float4 Blur(float2 uv) {
				if(_Radius <= 0)
					return tex2D(_MainTex, uv);
				float4 sum = float4(0, 0, 0, 0);
				float sumWeight = 0;
				const float dR = _Radius / 10;
				const float dTheta = TAU / 16;
				for(float r = 0; r < _Radius; r += dR) {
					float weight = r * dTheta * NormDist(r);
					for(float theta = 0; theta < TAU; theta += dTheta) {
						float2 offset = float2(r * cos(theta), r * sin(theta));
						float4 color = tex2D(_MainTex, uv + offset);
						sum += weight * color;
						sumWeight += weight;
					}
				}
				return sum / sumWeight;
			}

			float4 frag(v2f i) : SV_Target {
				return Blur(i.uv);
			}
			ENDCG
		}
	}
}