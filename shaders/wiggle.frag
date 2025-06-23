// today we are editing shaders
// i do not know how to edit shaders

#pragma header
//uniform float tx, ty; // x,y waves phase
uniform float iTime;

const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;

uniform int effectType;

#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

/**
 * How fast the waves move over time
 */
uniform float uSpeed;

/**
 * Number of waves over time
 */
uniform float uFrequency;

/**
 * How much the pixels are going to stretch over the waves
 */
uniform float uWaveAmplitude;

vec2 sineWave(vec2 pt)
{
	float x = 0.0;
	float y = 0.0;
	
	if (effectType == EFFECT_TYPE_DREAMY) 
	{
		float offsetX = sin(pt.y * uFrequency + iTime * uSpeed) * uWaveAmplitude;
                pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_WAVY) 
	{
		float offsetY = sin(pt.x * uFrequency + iTime * uSpeed) * uWaveAmplitude;
		pt.y += offsetY; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
	{
		x = sin(pt.x * uFrequency + iTime * uSpeed) * uWaveAmplitude;
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
	{
		y = sin(pt.y * uFrequency + iTime * uSpeed) * uWaveAmplitude;
	}
	else if (effectType == EFFECT_TYPE_FLAG)
	{
		y = sin(pt.y * uFrequency + 10.0 * pt.x + iTime * uSpeed) * uWaveAmplitude;
		x = sin(pt.x * uFrequency + 5.0 * pt.y + iTime * uSpeed) * uWaveAmplitude;
	}
	
	return vec2(pt.x + x, pt.y + y);
}

void mainImage()
{
	vec2 uv = sineWave(openfl_TextureCoordv);
	fragColor = texture(iChannel0, uv);
}