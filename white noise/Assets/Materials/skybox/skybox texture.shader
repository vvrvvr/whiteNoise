Shader "Custom/SingleTextureSkyboxTiledExposure"
{
    Properties
    {
        _MainTex("Skybox Texture", 2D) = "white" {}
        _MainTex_ST("MainTex Tiling/Offset", Vector) = (1,1,0,0)
        _Exposure("Exposure", Float) = 1.0
    }
    SubShader
    {
        Tags { "Queue" = "Background" "RenderType" = "Background" }
        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Exposure;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 dir : TEXCOORD0;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.dir = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 dir = normalize(i.dir);
                float2 uv;
                uv.x = 0.5 + atan2(dir.z, dir.x) / (2.0 * UNITY_PI);
                uv.y = 0.5 - asin(dir.y) / UNITY_PI;

                uv = uv * _MainTex_ST.xy + _MainTex_ST.zw;

                fixed4 col = tex2D(_MainTex, uv);
                return col * _Exposure;
            }
            ENDCG
        }
    }
    FallBack "RenderFX/Skybox"
}
