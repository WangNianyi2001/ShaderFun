Shader "ShaderFun/Twist" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		[ShowAsVector2] _Center("Center", Vector) = (.5, .5, 0, 0)
		_Rotation("Rotation", Range(-10, 10)) = 0
		_Range("Range", Range(0, 1)) = .1
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
			float2 _Center;
			float _Rotation;
			float _Range;

			float2 Twist(float2 offset) {
				float rotation = _Rotation * exp(-length(offset) / _Range);
				float c = cos(rotation), s = sin(rotation);
				float2x2 mat = float2x2(c, -s, s, c);
				return mul(offset, mat);
			}

			float4 frag(v2f i) : SV_Target{
				float2 uv = i.uv - _Center;
				uv = Twist(uv);
				return tex2D(_MainTex, uv + _Center);
			}
			ENDCG
		}
	}
}