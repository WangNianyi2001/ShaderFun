Shader "ShaderFun/Normal" {
	Properties {
		_LineLength ("LineLength", Float) = 0.03
		_LineColor ("LineColor", Color) = (1, 0, 0, 1)
	}
	
	SubShader {
		Pass {
			Tags { "RenderType" = "Opaque" }
 
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geo
			#include "UnityCG.cginc"

			float _LineLength;
			float4 _LineColor;

			struct GeometryInput {
				float4 pos : Position;
				float3 normal : Normal;
				float2 uv : TexCoord0;
			};

			struct FragmentInput {
				float4 pos : Position;
				float2 uv : TexCoord0;
			};

			GeometryInput vert(appdata_base v) {
				GeometryInput output = (GeometryInput)0;
				output.pos = mul(unity_ObjectToWorld, v.vertex);
				output.normal = normalize(UnityObjectToWorldNormal(v.normal));
				output.uv = float2(0, 0);
				return output;
			}

			[maxvertexcount(4)]
			void geo(point GeometryInput p[1], inout LineStream<FragmentInput> triStream) {
				FragmentInput f;
				f.pos = mul(UNITY_MATRIX_VP, p[0].pos);
				f.uv = float2(0, 0);
				triStream.Append(f);

				f.pos += mul(UNITY_MATRIX_VP, p[0].normal) * _LineLength;
				triStream.Append(f);
			}

			float4 frag(FragmentInput input) : Color {
				return _LineColor;
			}
			ENDCG
		}
	}
}
