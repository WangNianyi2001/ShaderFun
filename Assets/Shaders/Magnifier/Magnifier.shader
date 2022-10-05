Shader "ShaderFun/Magnifier" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_Radius("Radius", Float) = 10.0
		_Scale("Scale", Float) = 1.5
		[ShowAsVector2] _Position("Position", Vector) = (0, 0, 0, 0)
		[ShowAsVector2] _Resolution("Resolution", Vector) = (0, 0, 0, 0)
	}

	SubShader {
		Cull Off ZWrite Off ZTest Always

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
			float _Scale;
			float4 _Position;
			float4 _Resolution;

			float2 UvToScreen(float2 uv) {
				return uv * _Resolution.xy;
			}
			float2 ScreenToUv(float2 screen) {
				return screen / _Resolution.xy;
			}

			float2 MagnifyUv(float2 uv) {
				float2 screenPos = UvToScreen(uv);
				float2 delta = screenPos - _Position;
				if(length(delta) >= _Radius)
					return uv;
				return ScreenToUv(_Position + delta / _Scale);
			}

			float4 frag(v2f i) : SV_Target {
				return tex2D(_MainTex, MagnifyUv(i.uv));
			}
			ENDCG
		}
	}
}
