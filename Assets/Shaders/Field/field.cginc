#include "UnityCG.cginc"

static const float TAU = atan(1) * 8;
static const float PI = TAU / 2;

inline float CompressRange(float v) {
	return atan(v) / PI + .5f;
}

inline float ExpandRange(float v) {
	return tan((v - .5f) * PI);
}

inline float EncodeField(float v) {
	return EncodeFloatRGBA(CompressRange(v));
}

inline float DecodeField(float3 enc) {
	return ExpandRange(DecodeFloatRGBA(float4(enc, 0)));
}