Shader "Hide/OutlinePostprocess"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Pass
		{
			//Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _MainTex_ST, _OutlineColor;
			fixed2 _MainTex_TexelSize;

			struct appdata
			{
				fixed4 vertex : POSITION;
				fixed2 uv : TEXCOORD0;

			};
	
			struct v2f
			{
				fixed2 uv : TEXCOORD0;
				fixed2 taps[4] : TEXCOORD1;
				fixed4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				o.taps[0] = o.uv + _MainTex_TexelSize;
				o.taps[1] = o.uv - _MainTex_TexelSize;
				o.taps[2] = o.uv + _MainTex_TexelSize * fixed2(1, -1);
				o.taps[3] = o.uv - _MainTex_TexelSize * fixed2(1, -1);
				

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.uv);
			
				fixed t = tex2D(_MainTex, i.taps[0]).x;   // top
				fixed b = tex2D(_MainTex, i.taps[1]).x;   // bottom
				fixed l = tex2D(_MainTex, i.taps[2]).x;   // left
				fixed r = tex2D(_MainTex, i.taps[3]).x;   // right
				fixed total = t + b + l + r;
				fixed weight = abs(color.r * 4 - total);
				color = clamp(color, _OutlineColor, weight);
				
				if (distance(color.rgb,0) <= 0)
					discard;
					
				return _OutlineColor;
			}
			ENDCG
		}

	}
}
