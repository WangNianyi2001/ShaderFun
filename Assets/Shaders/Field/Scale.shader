Shader "ShaderFun/Field/Scale" {
	Properties {
		[MainTexture] Field("Field", 2D) = "gray" {}
		Scalar("Scalar", Float) = 1.0
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

			sampler2D Field;
			float Scalar;

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target{
				return EncodeField(DecodeField(tex2D(Field, i.uv)) * Scalar);
			}
			ENDCG
		}
	}
}
