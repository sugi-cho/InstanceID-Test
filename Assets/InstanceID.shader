Shader "Unlit/Test/InstanceID"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				half4 color : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			StructuredBuffer<float3> _Vertices;
			
			v2f vert (appdata v,uint vid : SV_VertexID, uint iid : SV_InstanceID)
			{
				v.vertex.xyz += _Vertices[vid];
				v.vertex.x += iid;
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = frac(half4(0.3, 0.6, 0.9, 1) * (1+iid));
				return o;
			}
			
			fixed4 frag (v2f i, uint pid : SV_PrimitiveID) : SV_Target
			{
				return i.color * frac(0.09*pid);
			}
			ENDCG
		}
	}
}
