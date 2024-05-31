/*
===============================================
Pathos Engine - Copyright Andrew Lucas

2016-2020
All Rights Reserved.
===============================================
*/

#ifndef PBSPV1FILE_H
#define PBSPV1FILE_H

#include "miptex.h"
#include "contents.h"
#include "miptex.h"

//
// BSP limits
//

#define PBSPV1_MAX_MAP_HULLS			4

#define PBSPV1_MAX_MAP_MODELS         262144
#define PBSPV1_MAX_MAP_BRUSHES        1048576
#define PBSPV1_MAX_MAP_ENTITIES       262144
#define PBSPV1_MAX_MAP_ENTSTRING      8388608

#define PBSPV1_MAX_MAP_PLANES         524288
#define PBSPV1_MAX_MAP_NODES          524288
#define PBSPV1_MAX_MAP_CLIPNODES      524288
#define PBSPV1_MAX_MAP_LEAFS          524288
#define PBSPV1_MAX_MAP_VERTS          524288
#define PBSPV1_MAX_MAP_FACES          524288
#define PBSPV1_MAX_MAP_MARKSURFACES   524288
#define PBSPV1_MAX_MAP_TEXINFO        262144
#define PBSPV1_MAX_MAP_EDGES          1048576
#define PBSPV1_MAX_MAP_SURFEDGES      2097152
#define PBSPV1_MAX_MAP_TEXTURES       262144
#define PBSPV1_MAX_MAP_LIGHTING       33554432
#define PBSPV1_MAX_MAP_VISIBILITY     67108864

#define PBSPV1_MAX_LIGHTMAPS			4
#define PBSPV1_LM_SAMPLE_SIZE			16

#define PBSPV1_NUM_AMBIENTS				4

#define PBSP_HEADER						(('P'<<24)+('S'<<16)+('B'<<8)+'P')
#define PBSP_VERSION					2

//
// BSP lumps
//
enum pbspv1_lumps_t
{
	PBSPV1_LUMP_ENTITIES = 0,
	PBSPV1_LUMP_PLANES,
	PBSPV1_LUMP_TEXTURES,
	PBSPV1_LUMP_VERTEXES,
	PBSPV1_LUMP_VISIBILITY,
	PBSPV1_LUMP_NODES,
	PBSPV1_LUMP_TEXINFO,
	PBSPV1_LUMP_FACES,
	PBSPV1_LUMP_LIGHTING,
	PBSPV1_LUMP_CLIPNODES,
	PBSPV1_LUMP_LEAFS,
	PBSPV1_LUMP_MARKSURFACES,
	PBSPV1_LUMP_EDGES,
	PBSPV1_LUMP_SURFEDGES,
	PBSPV1_LUMP_MODELS,
	PBSPV1_NB_LUMPS
};


//
// Header for Pathos BSP V1
//
struct dpbspv1header_t
{
	dpbspv1header_t():
		id(0),
		version(0)
	{
		memset(lumps, 0, sizeof(lumps));
	}

	Int32 id;
	Int32 version;
	lump_t lumps[NB_LUMPS];
};

//
// BSP file structures
//
struct dpbspv1model_t
{
	dpbspv1model_t():
		visleafs(0),
		firstface(0),
		numfaces(0)
	{
		memset(mins, 0, sizeof(mins));
		memset(maxs, 0, sizeof(maxs));
		memset(origin, 0, sizeof(origin));
		memset(headnode, 0, sizeof(headnode));
	}

	float mins[3];
	float maxs[3];
	Float origin[3];

	Int32 headnode[PBSPV1_MAX_MAP_HULLS];
	Int32 visleafs;

	Int32 firstface;
	Int32 numfaces;
};

struct dpbspv1vertex_t
{
	dpbspv1vertex_t()
	{
		memset(origin, 0, sizeof(origin));
	}

	Float origin[3];
};

struct dpbspv1plane_t
{
	dpbspv1plane_t():
		dist(0),
		type(0)
	{
		memset(normal, 0, sizeof(normal));
	}

	Float normal[3];
	Float dist;

	Int32 type;
};

struct dpbspv1node_t
{
	dpbspv1node_t():
		planenum(0),
		firstface(0),
		numfaces(0)
	{
		memset(children, 0, sizeof(children));
		memset(mins, 0, sizeof(mins));
		memset(maxs, 0, sizeof(maxs));
	}

	Int32 planenum;
	Int32 children[2];
	Int32 mins[3];
	Int32 maxs[3];

	Uint32 firstface;
	Uint32 numfaces;
};

struct dpbspv1clipnode_t
{
	dpbspv1clipnode_t():
		planenum(0)
	{
		memset(children, 0, sizeof(children));
	}

	Int32 planenum;
	Int32 children[2];
};

struct dpbspv1texinfo_t
{
	dpbspv1texinfo_t():
		miptex(0),
		flags(0)
	{
		memset(vecs, 0, sizeof(vecs));
	}

	Float vecs[2][4];
	Int32 miptex;
	Int32 flags;
};

struct dpbspv1edge_t
{
	Uint32 vertexes[2];
};

struct dpbspv1face_t
{
	dpbspv1face_t():
		planenum(0),
		side(0),
		firstedge(0),
		numedges(0),
		texinfo(0),
		lightoffset(0)
	{
		memset(lmstyles, 0, sizeof(lmstyles));
	}

	Uint32 planenum;
	Int32 side;

	Int32 firstedge;
	Int32 numedges;
	Int32 texinfo;

	byte lmstyles[PBSPV1_MAX_LIGHTMAPS];
	Int32 lightoffset;
};

struct dpbspv1leaf_t
{
	dpbspv1leaf_t():
		contents(0),
		visoffset(0),
		firstmarksurface(0),
		nummarksurfaces(0)
	{
		memset(mins, 0, sizeof(mins));
		memset(maxs, 0, sizeof(maxs));
		memset(ambient_level, 0, sizeof(ambient_level));
	}

	Int32 contents;
	Int32 visoffset;

	Int32 mins[3];
	Int32 maxs[3];

	Uint32 firstmarksurface;
	Uint32 nummarksurfaces;

	byte ambient_level[PBSPV1_NUM_AMBIENTS];
};
#endif //PBSPV1FILE_H