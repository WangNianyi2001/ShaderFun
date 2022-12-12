Shader "Final/Water" {
	Properties {
		_Color("Color", Color) = (0, 0, 0, 0)
		_Normal("Normal", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input {
			float2 uv_Normal;
		};

		float4 _Color;
		sampler2D _Normal;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = _Color;
			float2 uv = IN.uv_Normal;
			uv += _Time.y * float2(0, 1);
			o.Normal = UnpackNormal(tex2D(_Normal, uv));
			o.Metallic = 0;
			o.Smoothness = 1;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
