Shader "Final/Tree" {
	Properties {
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Dirt("Dirt", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
			float2 uv_Normal;
			float2 uv_Dirt;
		};

		sampler2D _MainTex;
		sampler2D _Normal;
		sampler2D _Dirt;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * tex2D(_Dirt, IN.uv_Dirt);
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			o.Metallic = 0;
			o.Smoothness = 0.2;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
