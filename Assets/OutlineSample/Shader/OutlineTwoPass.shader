Shader "Custom/OutlineTwoPass" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_Outline("Outline Edge", Float) = 1.07
		[ToggleOff] _isNormalExtrude("Nomral On", Float) = 0
	}

	CGINCLUDE
	struct Input {
		float2 uv_MainTex;
	};
	ENDCG

	SubShader {
		Tags { "RenderType"="Opaque" }

		//baseColor
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG

		//outline
		Cull Front
		CGPROGRAM 
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0


		float _Outline, _isNormalExtrude;
		float4 _OutlineColor;

		void vert(inout appdata_full v) {
			if (_isNormalExtrude)
				v.vertex.xyz += v.normal *_Outline * 0.1;
			else
				v.vertex.xyz *= _Outline;
 
		}

		void surf(Input IN, inout SurfaceOutput o) {
			o.Emission = _OutlineColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
