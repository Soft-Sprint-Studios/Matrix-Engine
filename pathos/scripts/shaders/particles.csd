CSD1   41612d06dda0b8a9eb1cc7d2e9f946cf    ~�    @   8   �� �  h  (  �  �  h  b  �  Z  h  �  #	  �%  h  M(  �  01  �  �3  q	  d=  �  '@  �	  �I  �  �L  �	  CV  �  AY  
  Qc  �  Of  6
  �p  �  �s  a
  �}  �  k�  G	  ��  �  9�  m	  ��  �  -�  �	  š  �  ��  �	  ��  �  o�  
  {�  �  ]�  7
  ��    ��  �
  6�    S�  �
  ��    �  �
  ��  �  x�  �	  4�  �  �  �	  �
 �  $ 
  1 �   [
  n$ �  P' �
  �1 �  �4 �
  _?   |B �
  vM   �P    �[   �^ K  j h  �l �	  Cv h  �x �	  �� h  �� 
  
� h  r� �	  C� �  � _
  e� �  (� �
  �� �  p� �
   � �  � �
  � �  � $  >� �  <� O  �� �  � 5
  G� �  �� [
  ) �  �	 �
  6 �   �
  �! �  �$ �
  �/ �  �2 %  �=   �@ s  _L   |O �  [   2^ �  �i �  }l �
  'w �  �y �
  ~� �  � �
   � �  � I  +� �  � o  |� �  ^� �  ��   � �  ��   �   (�   E� 9  #version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	float DIST_POWER = -0.02;
		vec3 dudvcolor = (2.0 * texture (rtexture0, ps_texcoord).xyz) - 1.0;
		vec2 fetch_tc = vec2(ps_texcoord.x + dudvcolor.x*DIST_POWER*scrsize.x, ps_texcoord.y + dudvcolor.y*DIST_POWER*scrsize.y);
		vec4 finalColor = texture(rtexture1, fetch_tc);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	float DIST_POWER = -0.02;
		vec3 dudvcolor = (2.0 * texture (rtexture0, ps_texcoord).xyz) - 1.0;
		vec2 fetch_tc = vec2(ps_texcoord.x + dudvcolor.x*DIST_POWER*scrsize.x, ps_texcoord.y + dudvcolor.y*DIST_POWER*scrsize.y);
		vec4 finalColor = texture(rtexture1, fetch_tc);
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	if(finalColor.a < 0.5)
			discard;
	oColor = finalColor;

}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 proj_lights_0_matrix;
uniform mat4 proj_lights_1_matrix;

in vec4 in_position;
in vec2 in_texcoord;
in vec4 in_color;

out vec4 ps_color;
out vec2 ps_texcoord;
out vec3 ps_vertexpos;
out vec4 ps_fragcoord;

out vec4 ps_proj_l0vertexcoord;
out vec4 ps_proj_l1vertexcoord;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	ps_proj_l0vertexcoord = proj_lights_0_matrix * position;
		ps_vertexpos = position.xyz;
	ps_proj_l1vertexcoord = proj_lights_1_matrix * position;
	vec4 fragcoord = position*projection;
	ps_fragcoord = fragcoord;
	gl_Position = fragcoord;	
	
	ps_texcoord = in_texcoord;
	ps_vertexpos = position.xyz;
	
	ps_color = in_color;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2D texture0;
uniform sampler2D proj_lights_0_texture;
uniform sampler2D proj_lights_1_texture;

uniform sampler2DRect rtexture0;
uniform sampler2DRect rtexture1;

uniform vec3 point_lights_0_origin;
uniform vec3 point_lights_0_color;
uniform float point_lights_0_radius;

uniform vec3 point_lights_1_origin;
uniform vec3 point_lights_1_color;
uniform float point_lights_1_radius;

uniform vec3 proj_lights_0_origin;
uniform vec3 proj_lights_0_color;
uniform float proj_lights_0_radius;

uniform vec3 proj_lights_1_origin;
uniform vec3 proj_lights_1_color;
uniform float proj_lights_1_radius;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float overbright;
uniform vec2 scrsize;

in vec4 ps_color;
in vec2 ps_texcoord;
in vec3 ps_vertexpos;
in vec4 ps_fragcoord;

in vec4 ps_proj_l0vertexcoord;
in vec4 ps_proj_l1vertexcoord;

out vec4 oColor;

vec3 AddPointLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);
	return light_color*attn;
}

vec3 AddProjLight( vec3 light_origin, vec3 light_color, float light_radius, vec3 v_origin, vec4 vertexCoord, sampler2D texture )
{
	float rad = light_radius*light_radius;
	vec3 dir = light_origin-v_origin;
	float dist = dot(dir, dir);
	float attn = (dist/rad-1)*-1;
	attn = clamp(attn, 0.0, 1.0);

	vec4 texclamp = max(vertexCoord, 0);
	vec4 sample = textureProj(texture, texclamp);

	return light_color*attn*sample.xyz;
}

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 finalColor = ps_color;
	finalColor.xyz += AddPointLight(point_lights_0_origin, point_lights_0_color, point_lights_0_radius, ps_vertexpos);
	finalColor.xyz += AddPointLight(point_lights_1_origin, point_lights_1_color, point_lights_1_radius, ps_vertexpos);
	finalColor.xyz += AddProjLight(proj_lights_0_origin, proj_lights_0_color, proj_lights_0_radius, ps_vertexpos, ps_proj_l0vertexcoord, proj_lights_0_texture);
	finalColor.xyz += AddProjLight(proj_lights_1_origin, proj_lights_1_color, proj_lights_1_radius, ps_vertexpos, ps_proj_l1vertexcoord, proj_lights_1_texture);
	finalColor.xyz = clamp(finalColor.xyz, 0.0, 1.0);
		vec4 texturecolor = texture(texture0, ps_texcoord.xy);
		
		finalColor.xyz = finalColor.xyz*texturecolor.xyz*(1.0+overbright);
		finalColor.w = ps_color.w*texturecolor.w;
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	finalColor.a = (finalColor.a - 0.5) / max(fwidth(finalColor.a), 0.0001) + 0.5;
	oColor = finalColor;

}
fog                                n�        num_point_lights                   ��        num_proj_lights                    N�        type                               ��        alphatest                          .�                                                                                                                                                                                                                                                                                                                                                                                                                                              