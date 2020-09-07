Shader "Custom/Dissolve" {
    Properties {
        _Color ("Color", Color) = (.8, .8, .8, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0, 1)) = 0.25
        _Metallic ("Metallic", Range(0, 1)) = 0.75
        [HDR] _Emission ("Emission", color) = (0,0,0)

        //Dissolve Properties
        _DissolveTexture ("Dissolve Texture", 2D) = "white" {}
        _DissolveAmount ("Dissolve Amount", Range(1, 0)) = 1


        //Shine Properties
        [HDR]_ShineColor("Color", Color) = (0, 1, 1, 1)
        _ShineRange("Range", Range(0, .2)) = 0.025
        _ShineFalloff("Falloff", Range(0.001, .2)) = 0.025
    }
    SubShader {
		Tags{ "RenderType" = "Opaque"}
		LOD 200
		Cull Off //doppelseitiges Materials

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
		fixed4 _Color;
        half _Smoothness;
        half _Metallic;
        half3 _Emission;

		//Dissolve properties
        sampler2D _DissolveTexture;
        float _DissolveAmount;

		//Shine properties
        float3 _ShineColor;
        float _ShineRange;
        float _ShineFalloff;

        struct Input {
            float2 uv_MainTex;
            float2 uv_DissolveTexture;
        };

        void surf (Input IN, inout SurfaceOutputStandard o) {

			//Dissolve Funktion
            float dissolve_value = tex2D(_DissolveTexture, IN.uv_MainTex).r;
            float visible =  _DissolveAmount - dissolve_value;
            clip(visible);

			//Shine Funktion
            float isShining = smoothstep(_ShineRange + _ShineFalloff, _ShineRange, visible);
            float3 shine = isShining * _ShineColor;

			//Shader Funktion
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            

            o.Albedo = c;
            o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
            o.Emission = _Emission + shine;
			
        }
		
        ENDCG
    }
	FallBack "Diffuse"

		
			
		
}