Shader "ShaderFun/Field/Plus" {
	Properties {
		[MainTexture] A("A", 2D) = "gray" {}
		B("B", 2D) = "gray" {}
		C("C", Float) = 1
	}

	SubShader {
		Tags { "RenderType" = "Opaque" }

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "field.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D A;
			sampler2D B;
			float C;

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				float a = DecodeField(tex2D(A, i.uv));
				float b = DecodeField(tex2D(B, i.uv));
				return EncodeField(a + b * C);
			}
			ENDCG
		}
	}
}
