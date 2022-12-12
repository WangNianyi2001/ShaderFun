Shader "Final/Tree" {
	Properties {
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void vert(inout appdata_full v) {
			float amplitude = pow((v.vertex.y / 2), 2) * .1;
			v.vertex.x += sin(_Time.z) * amplitude;
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Metallic = 0;
			o.Smoothness = 0.2;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
