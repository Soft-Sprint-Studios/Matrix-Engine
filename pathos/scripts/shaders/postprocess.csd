CSD1   1fe8725518c9dedd93ccf43e3d36db1e    �]     @      9^  P    [  z  �    �  �  �    �  �  A    L  �  �    �  �  �    �  �   �    �    �%    �&    �'    �(  �  �,    �-  �  �5    �6  �  �9    �:  �  c>    n?  b  �F    �G  _  :K    EL  q	  �U    �V    �Z    �[  
  #version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

uniform float gamma;
in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	vec4 color = texture(texture0, ps_texcoord);
		for(int i = 0; i < 4; i++)
			oColor[i] = pow(color[i], 1.0/gamma);
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	float offset[5] = float[]( 0.0, 1.0, 2.0, 3.0, 4.0 );
		float weight[5] = float[]( 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 );
	
		vec4 outcolor = texture(texture0, ps_texcoord)*weight[0];
		for(int i = 1; i < 5; i++)
		{
			outcolor += texture(texture0, ps_texcoord+vec2(offset[i], 0))*weight[i];
			outcolor += texture(texture0, ps_texcoord-vec2(offset[i], 0))*weight[i];
		}
		oColor = outcolor * color;
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	float offset[5] = float[]( 0.0, 1.0, 2.0, 3.0, 4.0 );
		float weight[5] = float[]( 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 );
	
		vec4 outcolor = texture(texture0, ps_texcoord)*weight[0];
		for(int i = 1; i < 5; i++)
		{
			outcolor += texture(texture0, ps_texcoord+vec2(0, offset[i]))*weight[i];
			outcolor += texture(texture0, ps_texcoord-vec2(0, offset[i]))*weight[i];
		}
		oColor = outcolor * color;
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

uniform float offset;
in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	vec2 texc = ps_texcoord;
		texc.x += (sin(texc.y * 0.03 + offset) * 10) * color.a;

		oColor = texture(texture0, texc) * color;
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

uniform sampler2DRect blurtexture;
in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	vec4 maintex = texture(texture0, ps_texcoord);
		vec4 blurtex = texture(blurtexture, ps_texcoord);
		oColor = maintex*(1.0-color.a)+blurtex*(color.a);
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	oColor = color;
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float timer;

const float permTexUnit = 1.0/256.0;		// Perm texture texel-size
const float permTexUnitHalf = 0.5/256.0;	// Half perm texture texel-size

const float grainamount = 0.05; //grain amount
float grainsize = 1.6; //grain particle size (1.5 - 2.5)
float lumamount = 1.0; //
float coloramount = 0.6;

//a random texture generator, but you can also use a pre-computed perturbation texture
vec4 rnm(in vec2 tc) 
{
    float noise =  sin(dot(tc + vec2(timer,timer),vec2(12.9898,78.233))) * 43758.5453;

	float noiseR =  fract(noise)*2.0-1.0;
	float noiseG =  fract(noise*1.2154)*2.0-1.0; 
	float noiseB =  fract(noise*1.3453)*2.0-1.0;
	float noiseA =  fract(noise*1.3647)*2.0-1.0;
	
	return vec4(noiseR,noiseG,noiseB,noiseA);
}

float fade(in float t) {
	return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float pnoise3D(in vec3 p)
{
	vec3 pi = permTexUnit*floor(p)+permTexUnitHalf; // Integer part, scaled so +1 moves permTexUnit texel
	// and offset 1/2 texel to sample texel centers
	vec3 pf = fract(p);     // Fractional part for interpolation

	// Noise contributions from (x=0, y=0), z=0 and z=1
	float perm00 = rnm(pi.xy).a ;
	vec3  grad000 = rnm(vec2(perm00, pi.z)).rgb * 4.0 - 1.0;
	float n000 = dot(grad000, pf);
	vec3  grad001 = rnm(vec2(perm00, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n001 = dot(grad001, pf - vec3(0.0, 0.0, 1.0));

	// Noise contributions from (x=0, y=1), z=0 and z=1
	float perm01 = rnm(pi.xy + vec2(0.0, permTexUnit)).a ;
	vec3  grad010 = rnm(vec2(perm01, pi.z)).rgb * 4.0 - 1.0;
	float n010 = dot(grad010, pf - vec3(0.0, 1.0, 0.0));
	vec3  grad011 = rnm(vec2(perm01, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n011 = dot(grad011, pf - vec3(0.0, 1.0, 1.0));

	// Noise contributions from (x=1, y=0), z=0 and z=1
	float perm10 = rnm(pi.xy + vec2(permTexUnit, 0.0)).a ;
	vec3  grad100 = rnm(vec2(perm10, pi.z)).rgb * 4.0 - 1.0;
	float n100 = dot(grad100, pf - vec3(1.0, 0.0, 0.0));
	vec3  grad101 = rnm(vec2(perm10, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n101 = dot(grad101, pf - vec3(1.0, 0.0, 1.0));

	// Noise contributions from (x=1, y=1), z=0 and z=1
	float perm11 = rnm(pi.xy + vec2(permTexUnit, permTexUnit)).a ;
	vec3  grad110 = rnm(vec2(perm11, pi.z)).rgb * 4.0 - 1.0;
	float n110 = dot(grad110, pf - vec3(1.0, 1.0, 0.0));
	vec3  grad111 = rnm(vec2(perm11, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n111 = dot(grad111, pf - vec3(1.0, 1.0, 1.0));

	// Blend contributions along x
	vec4 n_x = mix(vec4(n000, n001, n010, n011), vec4(n100, n101, n110, n111), fade(pf.x));

	// Blend contributions along y
	vec2 n_xy = mix(n_x.xy, n_x.zw, fade(pf.y));

	// Blend contributions along z
	float n_xyz = mix(n_xy.x, n_xy.y, fade(pf.z));

	// We're done, return the final noise value.
	return n_xyz;
}

//2d coordinate orientation thing
vec2 coordRot(in vec2 tc, in float angle)
{
	float aspect = screenwidth/screenheight;
	float rotX = ((tc.x*2.0-1.0)*aspect*cos(angle)) - ((tc.y*2.0-1.0)*sin(angle));
	float rotY = ((tc.y*2.0-1.0)*cos(angle)) + ((tc.x*2.0-1.0)*aspect*sin(angle));
	rotX = ((rotX/aspect)*0.5+0.5);
	rotY = rotY*0.5+0.5;
	return vec2(rotX,rotY);
}
void main()
{
	vec2 norm_texcoords = vec2(ps_texcoord.x/screenwidth, ps_texcoord.y/screenheight);
	
		vec3 rotOffset = vec3(1.425,3.892,5.835); //rotation offset values	
		vec2 rotCoordsR = coordRot(norm_texcoords, timer*0.25 + rotOffset.x);
		vec2 rotCoordsG = coordRot(norm_texcoords, timer*0.25 + rotOffset.y);
		vec2 rotCoordsB = coordRot(norm_texcoords, timer*0.25 + rotOffset.z);
		
		vec3 noise;
		noise.r = vec3(pnoise3D(vec3(rotCoordsR*vec2(screenwidth/grainsize,screenheight/grainsize),0.0))).r;
		noise.g = mix(noise.r,pnoise3D(vec3(rotCoordsG*vec2(screenwidth/grainsize,screenheight/grainsize),1.0)), coloramount);
		noise.b = mix(noise.r,pnoise3D(vec3(rotCoordsB*vec2(screenwidth/grainsize,screenheight/grainsize),2.0)), coloramount);
		
		vec3 col = texture(texture0, ps_texcoord).rgb;

		//noisiness response curve based on scene luminance
		vec3 lumcoeff = vec3(0.299,0.587,0.114);
		float luminance = mix(0.0,dot(col, lumcoeff),lumamount);
		luminance = clamp(luminance, 0.25, 0.75);
		float lum = smoothstep(0.2,0.0,luminance);
		lum += luminance;

		noise = mix(noise,vec3(0.0),pow(lum,4.0));
		col = col+noise*grainamount;
	   
		oColor =  vec4(col,1.0);	
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	oColor = texture(texture0, ps_texcoord);
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float chromaticStrength;
void main()
{
	// Calculate offsets based on chromatic strength and screen size
    vec2 offsetR = vec2(chromaticStrength / screenwidth, 0.0);
    vec2 offsetG = vec2(-chromaticStrength / screenwidth, 0.0);
    vec2 offsetB = vec2(0.0, chromaticStrength / screenheight);

    // Sample the texture with different offsets for each color channel
    vec4 colorR = texture(texture0, ps_texcoord + offsetR);
    vec4 colorG = texture(texture0, ps_texcoord + offsetG);
    vec4 colorB = texture(texture0, ps_texcoord + offsetB);

    // Combine the color channels with their respective offsets
    oColor.r = colorR.r;
    oColor.g = colorG.g;
    oColor.b = colorB.b;
    oColor.a = (colorR.a + colorG.a + colorB.a) / 3.0;
    }
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float FXAAStrength;
void main()
{
	// Sample the current pixel color
    vec4 currentColor = texture(texture0, ps_texcoord);
    
    // Define pixel offsets for sampling surrounding pixels
    vec2 offsets[4] = vec2[4](
        vec2(-1.0, 0.0) * vec2(FXAAStrength / screenwidth, 0.0),
        vec2(1.0, 0.0) * vec2(FXAAStrength / screenwidth, 0.0),
        vec2(0.0, -1.0) * vec2(0.0, FXAAStrength / screenheight),
        vec2(0.0, 1.0) * vec2(0.0, FXAAStrength / screenheight)
    );

    // Sample the four surrounding pixels
    vec4 leftColor = texture(texture0, ps_texcoord + offsets[0]);
    vec4 rightColor = texture(texture0, ps_texcoord + offsets[1]);
    vec4 topColor = texture(texture0, ps_texcoord + offsets[2]);
    vec4 bottomColor = texture(texture0, ps_texcoord + offsets[3]);

    // Calculate the luminance difference with neighboring pixels
    float lumaCurrent = dot(currentColor.rgb, vec3(0.299, 0.587, 0.114));
    float lumaLeft = dot(leftColor.rgb, vec3(0.299, 0.587, 0.114));
    float lumaRight = dot(rightColor.rgb, vec3(0.299, 0.587, 0.114));
    float lumaTop = dot(topColor.rgb, vec3(0.299, 0.587, 0.114));
    float lumaBottom = dot(bottomColor.rgb, vec3(0.299, 0.587, 0.114));

    // Calculate the anti-aliasing effect
    float lumaDiffX = abs(lumaLeft - lumaRight);
    float lumaDiffY = abs(lumaTop - lumaBottom);
    float maxLumaDiff = max(lumaDiffX, lumaDiffY);

    vec4 smoothedColor = currentColor;
    if (maxLumaDiff > FXAAStrength) {
        // Interpolate the current color with the average of the neighboring pixels
        smoothedColor = mix(currentColor, (leftColor + rightColor + topColor + bottomColor) / 4.0, maxLumaDiff / FXAAStrength);
    }

    // Output the final color
    oColor = smoothedColor;
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float BWStrength;
void main()
{
	// Sample the texture at the current coordinates
    vec4 color = texture(texture0, ps_texcoord);

    // Calculate luminance using the formula (0.3 * R + 0.59 * G + 0.11 * B)
    float luminance = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;

    // Mix the original color with grayscale based on the black and white strength parameter
    vec4 grayscaleColor = vec4(vec3(luminance), color.a);
    oColor = mix(color, grayscaleColor, BWStrength);
    }
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float bleachStrength;
void main()
{
	// Sample the color from the input texture
        vec4 color = texture(texture0, ps_texcoord);
        
        // Calculate the grayscale value using the luminance formula
        float grayscale = dot(color.rgb, vec3(0.299, 0.587, 0.114));
        
        // Apply desaturation using a linear interpolation between color and grayscale
        vec3 desaturatedColor = mix(color.rgb, vec3(grayscale), bleachStrength);

        // Increase contrast based on the bleachStrength uniform
        vec3 contrastColor = desaturatedColor * bleachStrength + (1.0 - bleachStrength) * desaturatedColor;

        // Assign the output color
        oColor = vec4(contrastColor, color.a);
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

const float bloomThreshold = 0.5;
uniform float bloomStrength;
void main()
{
	vec4 color = texture(texture0, ps_texcoord);
    vec4 brightColor = max(color - vec4(bloomThreshold), vec4(0.0));
    vec2 offsets[49] = vec2[](
        vec2(-3, -3), vec2(-2, -3), vec2(-1, -3), vec2(0, -3), vec2(1, -3), vec2(2, -3), vec2(3, -3),
        vec2(-3, -2), vec2(-2, -2), vec2(-1, -2), vec2(0, -2), vec2(1, -2), vec2(2, -2), vec2(3, -2),
        vec2(-3, -1), vec2(-2, -1), vec2(-1, -1), vec2(0, -1), vec2(1, -1), vec2(2, -1), vec2(3, -1),
        vec2(-3, 0), vec2(-2, 0), vec2(-1, 0), vec2(0, 0), vec2(1, 0), vec2(2, 0), vec2(3, 0),
        vec2(-3, 1), vec2(-2, 1), vec2(-1, 1), vec2(0, 1), vec2(1, 1), vec2(2, 1), vec2(3, 1),
        vec2(-3, 2), vec2(-2, 2), vec2(-1, 2), vec2(0, 2), vec2(1, 2), vec2(2, 2), vec2(3, 2),
        vec2(-3, 3), vec2(-2, 3), vec2(-1, 3), vec2(0, 3), vec2(1, 3), vec2(2, 3), vec2(3, 3)
    );
    float weights[49] = float[](
        0.004, 0.008, 0.012, 0.015, 0.012, 0.008, 0.004,
        0.008, 0.016, 0.025, 0.033, 0.025, 0.016, 0.008,
        0.012, 0.025, 0.045, 0.055, 0.045, 0.025, 0.012,
        0.015, 0.033, 0.055, 0.068, 0.055, 0.033, 0.015,
        0.012, 0.025, 0.045, 0.055, 0.045, 0.025, 0.012,
        0.008, 0.016, 0.025, 0.033, 0.025, 0.016, 0.008,
        0.004, 0.008, 0.012, 0.015, 0.012, 0.008, 0.004
    );
    vec4 bloomColor = vec4(0.0);
    for (int i = 0; i < 49; i++) {
        vec2 offsetCoord = ps_texcoord + offsets[i] * bloomStrength;
        bloomColor += texture(texture0, offsetCoord) * weights[i];
    }
    bloomColor *= 0.5;
    oColor = color + bloomColor * bloomStrength;
    }
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float vignetteStrength;
uniform float vignetteRadius;
void main()
{
	// Sample the texture color
    vec4 color = texture(texture0, ps_texcoord);

    // Calculate the normalized screen coordinates
    vec2 uv = vec2(ps_texcoord.x / screenwidth, ps_texcoord.y / screenheight);

    // Calculate the distance from the center
    vec2 centeredUV = uv - vec2(0.5, 0.5);
    float distance = length(centeredUV);

    // Apply the vignette effect
    float vignette = smoothstep(vignetteRadius, vignetteRadius - vignetteStrength, distance);
    color.rgb *= vignette;

    // Output the final color
    oColor = color;
	}
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float SSAORadius;
uniform float SSAOStrength;
void main()
{
	// Sample the current pixel color and compute luminance
    vec4 currentColor = texture(texture0, ps_texcoord);
    float currentLuminance = dot(currentColor.rgb, vec3(0.299, 0.587, 0.114));
    
    // Parameters for the effect
    int samples = 256; // Number of samples around the current pixel (adjust as needed)
    float threshold = 0.05; // Threshold for luminance difference to consider (adjust as needed)

    
    // Initialize the occlusion value
    float occlusion = 0.0;
    float totalWeight = 0.0;
    
    // Sample surrounding pixels
    for (int i = 0; i < samples; i++) {
        // Calculate angle for sampling around the current pixel
        float angle = 2.0 * 3.14159265 * float(i) / float(samples);
        // Calculate the offset for the sample
        vec2 offset = vec2(cos(angle), sin(angle)) * SSAORadius;
        
        // Convert the offset to texture coordinates
        vec2 sampleCoord = ps_texcoord + offset / vec2(screenwidth, screenheight);
        
        // Sample the neighboring pixel and compute its luminance
        vec4 neighborColor = texture(texture0, sampleCoord);
        float neighborLuminance = dot(neighborColor.rgb, vec3(0.299, 0.587, 0.114));
        
        // Calculate the absolute luminance difference
        float luminanceDifference = abs(currentLuminance - neighborLuminance);
        
        // Compute weight based on luminance difference
        float weight = exp(-luminanceDifference / threshold);
        
        // Accumulate occlusion based on luminance difference and weight
        if (luminanceDifference > threshold) {
            occlusion += weight * luminanceDifference;
        }
        
        totalWeight += weight;
    }
    
    // Normalize occlusion based on the total weight
    occlusion /= totalWeight;
    
    // Apply SSAO strength
    occlusion *= SSAOStrength;
    
    // Darken the current pixel based on occlusion
    vec3 occludedColor = currentColor.rgb * (1.0 - occlusion);
    
    // Output the final color
    oColor = vec4(occludedColor, currentColor.a);
    }
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float underExposure;
uniform float overExposure;
void main()
{
	vec4 color = texture(texture0, ps_texcoord);
    vec3 lumCoeff = vec3(0.2126, 0.7152, 0.0722);
    float luminance = dot(color.rgb, lumCoeff);
    
    float mappedLuminance = luminance / (1.0 + luminance);
    mappedLuminance = clamp(mappedLuminance, underExposure, overExposure);
    
    float gamma = 2.2;
    vec3 toneMappedColor = pow(color.rgb, vec3(1.0 / gamma)) * mappedLuminance;
    
    float contrast = 1.2;
    toneMappedColor = mix(vec3(0.5), toneMappedColor, contrast);
    
    float saturation = 1.5;
    toneMappedColor = mix(vec3(0.0), toneMappedColor, saturation);
    
    toneMappedColor = clamp(toneMappedColor, vec3(underExposure), vec3(overExposure));
    oColor = vec4(toneMappedColor, color.a);
    }
#version 460

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 460
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float sepiaStrength;
void main()
{
	vec4 color = texture(texture0, ps_texcoord);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 sepiaColor = vec3(1.0, 0.95, 0.82);
    vec3 sepia = mix(vec3(gray), sepiaColor, sepiaStrength);
    oColor = vec4(sepia, color.a);
    }
pp_type                            ^                   	 
       