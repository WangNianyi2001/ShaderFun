Shader "ShaderFun/Water/Display" {
	Properties {
		[MainTexture] Height("Height Field", 2D) = "gray" {}
		Laplace("Laplace Field", 2D) = "gray" {}
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
			sampler2D Laplace;

			v2f vert(appdata v) {
				v2f o;
				float height = DecodeField(tex2Dlod(Height, float4(v.uv, 0, 1)));
				v.vertex.y += height;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target {
				float height = DecodeField(tex2D(Height, i.uv));
				float3 res = float3(.5, .5, 1);
				res += float3(1, 1, 0) * height;
				return float4(.5, res.gb, 1);
			}
			ENDCG
		}
	}
}