Shader "Custom/RotateShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)

		_MainTex ("Texture1 Background)", 2D) = "white" {}
		_rotation0 ("rotation speed 1",Float) = 0.0

		_MainTex1 ("Texture 2 (Multiply)", 2D) = "white" {}
		_rotation1 ("rotation speed 2",Float) = 0.0

		_MainTex2 ("Texture 3 (Multiply)", 2D) = "white" {}
		_rotation2 ("rotation speed 3",Float) = 0.0

		_MainTex3 ("Texture 4 (Multiply)", 2D) = "white" {}
		_rotation3("rotation speed 4",Float) = 0.0

		_MainTex4 ("Texture5 (Overlay)", 2D) = "white" {}
		_rotation4 ("rotation speed 5",Float) = 0.0
	
		_MainTex5 ("Texture6 (Multiply)", 2D) = "white" {}
		_rotation5("rotation speed 6",Float) = 0.0

		_MainTex6 ("Grain1 (Screen)", 2D) = "white" {}
		_rotation6("rotation speed 7",Float) = 0.0

		_MainTex7 ("Grain2 (Screen)", 2D) = "white" {}
		_rotation7("rotation speed 8",Float) = 0.0

		_MainTex8 ("Grain3 (Screen)", 2D) = "white" {}
		_rotation8("rotation speed 9",Float) = 0.0

		_MainTex9 ("Grain4 (Screen)", 2D) = "white" {}
		_rotation9("rotation speed 10",Float) = 0.0

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.5
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows  

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _MainTex1;
		sampler2D _MainTex2;
		sampler2D _MainTex3;
		sampler2D _MainTex4;
		sampler2D _MainTex5;
		sampler2D _MainTex6;
		sampler2D _MainTex7;
		sampler2D _MainTex8;
		sampler2D _MainTex9;
		float _rotation0;
		float _rotation1;
		float _rotation2;
		float _rotation3;
		float _rotation4;
		float _rotation5;
		float _rotation6;
		float _rotation7;
		float _rotation8;
		float _rotation9;

	 

		struct Input {
			float2 uv_MainTex   : TEXCOORD0; 
		};
	 
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		fixed4 Multiply (half4 a, half4 b)
		{ 
			half4 r = a * b;
			r.a = b.a;
			return r;
		}


		fixed4 Screen (fixed4 a, fixed4 b) 
		{ 	
			fixed4 r = 1.0 - (1.0 - a) * (1.0 - b);
			r.a = b.a;
			return r;
		}

		fixed4 Overlay (fixed4 a, fixed4 b) 
		{
			fixed4 r = a > .5 ? 1.0 - 2.0 * (1.0 - a) * (1.0 - b) : 2.0 * a * b;
			r.a = b.a;
			return r;
		}

		float2 rotate(float rotationSpeed, float2 texCoordinates){
			float2 returnVal= texCoordinates;
         	returnVal-=0.5;
            float s = sin ( rotationSpeed * _Time );
            float c = cos ( rotationSpeed * _Time );
            float2x2 rotationMatrix = float2x2( c, -s, s, c);
            rotationMatrix *=0.5;
            rotationMatrix +=0.5;
            rotationMatrix = rotationMatrix * 2-1;
            returnVal = mul ( returnVal, rotationMatrix );
            returnVal+= 0.5;
            return returnVal;
        }
 

		void surf (Input IN, inout SurfaceOutputStandard o) { 

			half4 c = tex2D (_MainTex, rotate(_rotation0, IN.uv_MainTex)) * _Color;
		 	half4 c2 = tex2D (_MainTex1, rotate(_rotation1, IN.uv_MainTex));
		 	half4 c3 = tex2D (_MainTex2, rotate(_rotation2, IN.uv_MainTex));
		 	half4 c4 = tex2D (_MainTex3, rotate(_rotation3, IN.uv_MainTex));
		 	half4 c5 = tex2D (_MainTex4, rotate(_rotation4, IN.uv_MainTex));
		 	half4 c6 = tex2D (_MainTex5, rotate(_rotation5, IN.uv_MainTex));
		 	half4 c7 = tex2D (_MainTex6, rotate(_rotation6, IN.uv_MainTex));
		 	half4 c8 = tex2D (_MainTex7, rotate(_rotation7, IN.uv_MainTex));
		 	half4 c9 = tex2D (_MainTex8, rotate(_rotation8, IN.uv_MainTex));
		 	half4 c10 = tex2D (_MainTex9, rotate(_rotation9, IN.uv_MainTex));
		 	if(c.b!=0){
			 	c = Multiply(c2,c);
			 	c = Multiply(c3,c);
			 	c = Multiply(c4,c);
			 	c = Overlay(c5,c);
			 	c = Multiply(c6,c);
			 	c = Screen(c7,c);
			 	c = Screen(c8,c);
			 	c = Screen(c9,c);
		 		c = Screen(c10,c);
		 	}
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}