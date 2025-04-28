//GIMS IV 4 layer blend shader
//
//If you know how to improve this or make another GTA IV shaders, contact me:
//3Doomer2@gmail.com
//

//3D MAX specific:
string ParamID = "0x0";

//Globals:
float4x4 gWorldViewProj : WorldViewProjection;

//Untweakable parameters, coming from GIMS Evo IV:
float BumpPower
<
	string UIName = "Bump power";
>;
float RefPower
<
	string UIName = "Reflection power";
>;
float SpecMapPower
<
	string UIName = "Specular map power";
>;
float SpecPower
<
	string UIName = "Specularity";
>;
float LightPower
<
	string UIName = "Light power";
>;
float3 DiffColor
<
	string UIName = "Diffuse color";
>;
float3 SpecMask
<
	string UIName = "Specular mask";
>;
float3 DirtMask
<
	string UIName = "Dirt mask";
>;
float3 SkinColor
<
	string UIName = "Skin color";
>;
float3 GrassColor
<
	string UIName = "Grass color";
>;
texture TexDiff
<
	string UIName = "Diffuse";
>;
texture TexDiff2
<
	string UIName = "Diffuse 2";
>;
texture TexBump
<
	string UIName = "Bump";
>;
texture TexSpec
<
	string UIName = "Specular";
>;
texture TexRef
<
	string UIName = "Reflection";
>;
texture TexDirt
<
	string UIName = "Dirt map";
>;
texture TexLayer1
<
	string UIName = "Blend layer 1";
>;
texture TexLayer2
<
	string UIName = "Blend layer 2";
>;
texture TexLayer3
<
	string UIName = "Blend layer 3";
>;
texture TexLayer4
<
	string UIName = "Blend layer 4";
>;
texture GrassMap
<
	string UIName = "Grass";
>;

//Channel mapping:
int texcoord0 : Texcoord
<
	int Texcoord = 0;
	int MapChannel = 0; //vertex color
	string UIWidget = "None";
>;
int texcoord1 : Texcoord
<
	int Texcoord = 1;
	int MapChannel = 1;
	string UIWidget = "None";
>;
int texcoord2 : Texcoord
<
	int Texcoord = 2;
	int MapChannel = 2;
	string UIWidget = "None";
>;
int texcoord3 : Texcoord
<
	int Texcoord = 3;
	int MapChannel = 3;
	string UIWidget = "None";
>;
int texcoord4 : Texcoord
<
	int Texcoord = 4;
	int MapChannel = 4;
	string UIWidget = "None";
>;
int texcoord5 : Texcoord
<
	int Texcoord = 5;
	int MapChannel = 5;
	string UIWidget = "None";
>;
int texcoord6 : Texcoord
<
	int Texcoord = 6;
	int MapChannel = 6;
	string UIWidget = "None";
>;

//Texture samplers:
sampler2D sampler_1 = sampler_state
{
	Texture = <TexLayer1>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};

sampler2D sampler_2 = sampler_state 
{
	Texture = <TexLayer2>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};
sampler2D sampler_3 = sampler_state 
{
	Texture = <TexLayer3>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};
sampler2D sampler_4 = sampler_state 
{
	Texture = <TexLayer4>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};

//Structures:
struct VSh
{
	float4 Position			: POSITION;
	float4 Colour			: TEXCOORD0;
	float2 UV1				: TEXCOORD1;
	float2 UV2				: TEXCOORD2;
	float2 UV3				: TEXCOORD3;
	float2 UV4				: TEXCOORD4;
	float2 Mask1			: TEXCOORD5;
	float2 Mask2			: TEXCOORD6;
};
struct PSh
{
	float4 Colour	: COLOR0;
};

//Functions:
VSh VS(VSh vsIn) 
{
	VSh vsOut;                                                                                                                                                                                                                                                                                                                                  
   	vsOut.Position = mul(vsIn.Position, gWorldViewProj);
  	vsOut.Colour = vsIn.Colour;
 	vsOut.UV1 = vsIn.UV1;
   	vsOut.UV2 = vsIn.UV2;
   	vsOut.UV3 = vsIn.UV3;
   	vsOut.UV4 = vsIn.UV4;
  	vsOut.Mask1 = vsIn.Mask1;
 	vsOut.Mask2 = vsIn.Mask2;
  	return vsOut;
}
PSh PS(VSh psIn)
{
	PSh psOut;
	float4 r0 = tex2D(sampler_1, psIn.UV1);
	float4 r1 = tex2D(sampler_2, psIn.UV2);
	float4 texCol2 = tex2D(sampler_3, psIn.UV3);
	float4 texCol3 = tex2D(sampler_4, psIn.UV4);
	r0.w = r1.w * psIn.Mask1.y;
	float4 r2;
	r2.xyz = lerp(r0, r1, r0.w); 
	r2.w = 0;
	r0 = texCol2;
	r0.w *= psIn.Mask2.x;
	r1.xyz = lerp(r2, r0, r0.w); 		
	r0 = texCol3;
	r0.w *= psIn.Mask2.y;
	psOut.Colour.rgb = lerp(r1, r0, r0.w) * psIn.Colour.rgb;
	psOut.Colour.a = 1;
	return psOut;
}

//Techniques:
technique Draw
{
	pass p0
	{		
		AlphaBlendEnable = true;
		CullMode = CW;
		SrcBlend = SrcAlpha;
		DestBlend = InvSrcAlpha;
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS();
	}
}
