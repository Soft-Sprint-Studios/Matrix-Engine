#ifndef BSPFILE_H__
#define BSPFILE_H__
#include "cmdlib.h" //--vluzacn

#if _MSC_VER >= 1000
#pragma once
#endif
#include "../../common/datatypes.h"

// upper design bounds

#define MAX_MAP_HULLS            4
// hard limit

#define MAX_MAP_MODELS            262144

#define MAX_MAP_BRUSHES           1048576

#define MAX_ENGINE_ENTITIES       262144
#define MAX_MAP_ENTITIES          262144

#define MAX_MAP_ENTSTRING         (8388608) // 8MB

#define MAX_MAP_PLANES            524288
#define MAX_INTERNAL_MAP_PLANES   524288

#define MAX_MAP_NODES             524288
#define MAX_MAP_CLIPNODES         524288

#define MAX_MAP_LEAFS             524288
#define MAX_MAP_LEAFS_ENGINE      524288
#define MAX_MAP_VERTS             524288
#define MAX_MAP_FACES             524288
#define MAX_MAP_WORLDFACES        524288

#define MAX_MAP_MARKSURFACES      524288

#define MAX_MAP_TEXTURES          262144

#define MAX_MAP_TEXINFO           524288

#define MAX_MAP_EDGES             1048576
#define MAX_MAP_SURFEDGES         2097152

#define DEFAULT_MAX_MAP_MIPTEX    0x2000000 // 32MB

#define DEFAULT_MAX_MAP_LIGHTDATA 0x3000000 // 48MB

#define MAX_MAP_VISIBILITY        0x800000 // 8MB


// these are for entity key:value pairs
#define MAX_KEY                 128 //32 //vluzacn
#define MAX_VAL               4096 // the name used to be MAX_VALUE //vluzacn
// quote from yahn: 'probably can raise these values if needed'

// texture size limit

#define MAX_TEXTURE_SIZE     67108864 // 16384 * 16384 * sizeof(short) * 3 / 2

#define TEXTURE_STEP        16 // this constant was previously defined in lightmap.cpp. --vluzacn
#define MAX_SURFACE_EXTENT  32 // if lightmap extent exceeds 16, the map will not be able to load in 'Software' renderer and HLDS. //--vluzacn

#define ENGINE_ENTITY_RANGE 262144
//=============================================================================

#define PBSP_HEADER						(('P'<<24)+('S'<<16)+('B'<<8)+'P')
#define PBSP_VERSION					2

#define TOOLVERSION 2


//
// BSP File Structures
//


typedef struct
{
    int             fileofs, filelen;
}
lump_t;

#define LUMP_ENTITIES      0
#define LUMP_PLANES        1
#define LUMP_TEXTURES      2
#define LUMP_VERTEXES      3
#define LUMP_VISIBILITY    4
#define LUMP_NODES         5
#define LUMP_TEXINFO       6
#define LUMP_FACES         7
#define LUMP_LIGHTING      8
#define LUMP_CLIPNODES     9
#define LUMP_LEAFS        10
#define LUMP_MARKSURFACES 11
#define LUMP_EDGES        12
#define LUMP_SURFEDGES    13
#define LUMP_MODELS       14
#define HEADER_LUMPS      15

typedef struct
{
    float           mins[3], maxs[3];
    float           origin[3];
    int             headnode[MAX_MAP_HULLS];
    int             visleafs;                              // not including the solid leaf 0
    int             firstface, numfaces;
}
dmodel_t;

typedef struct
{
    int				id;
    int             version;
    lump_t          lumps[HEADER_LUMPS];
}
dheader_t;

typedef struct
{
    int             nummiptex;
    int             dataofs[4];                            // [nummiptex]
}
dmiptexlump_t;

#define MIPLEVELS   4
typedef struct miptex_s
{
    char            name[16];
    unsigned        width, height;
    unsigned        offsets[MIPLEVELS];                    // four mip maps stored
}
miptex_t;

typedef struct
{
    float           point[3];
}
dvertex_t;

typedef struct
{
    float           normal[3];
    float           dist;
    planetypes      type;                                  // PLANE_X - PLANE_ANYZ ?remove? trivial to regenerate
}
dplane_t;

typedef enum
{
    CONTENTS_EMPTY = -1,
    CONTENTS_SOLID = -2,
    CONTENTS_WATER = -3,
    CONTENTS_SLIME = -4,
    CONTENTS_LAVA = -5,
    CONTENTS_SKY = -6,
    CONTENTS_ORIGIN = -7,                                  // removed at csg time

    CONTENTS_CURRENT_0 = -9,
    CONTENTS_CURRENT_90 = -10,
    CONTENTS_CURRENT_180 = -11,
    CONTENTS_CURRENT_270 = -12,
    CONTENTS_CURRENT_UP = -13,
    CONTENTS_CURRENT_DOWN = -14,

    CONTENTS_TRANSLUCENT = -15,
    CONTENTS_HINT = -16,     // Filters down to CONTENTS_EMPTY by bsp, ENGINE SHOULD NEVER SEE THIS

    CONTENTS_NULL = -17,     // AJM  // removed in csg and bsp, VIS or RAD shouldnt have to deal with this, only clip planes!


	CONTENTS_BOUNDINGBOX = -19, // similar to CONTENTS_ORIGIN

	CONTENTS_TOEMPTY = -32,
}
contents_t;

typedef struct
{
    int             planenum;
    int				children[2];                           // negative numbers are -(leafs+1), not nodes
    Int32           mins[3];                               // for sphere culling
    Int32           maxs[3];
    unsigned int	firstface;
    unsigned int	numfaces;                              // counting both sides
}
dnode_t;

typedef struct
{
    int             planenum;
    int				children[2];                           // negative numbers are contents
}
dclipnode_t;

typedef struct texinfo_s
{
    float           vecs[2][4];                            // [s/t][xyz offset]
    int             miptex;
    int             flags;
}
texinfo_t;

#define TEX_SPECIAL     1                                  // sky or slime or null, no lightmap or 256 subdivision

// note that edge 0 is never used, because negative edge nums are used for
// counterclockwise use of the edge in a face
typedef struct
{
    unsigned int  v[2];                                  // vertex numbers
}
dedge_t;

#define MAXLIGHTMAPS    4
typedef struct
{
    unsigned int	planenum;
    int           side;

    int             firstedge;                             // we must support > 64k edges
    int           numedges;
    int           texinfo;

    // lighting info
    byte            styles[MAXLIGHTMAPS];
    int             lightofs;                              // start of [numstyles*surfsize] samples
}
dface_t;

#define AMBIENT_WATER   0
#define AMBIENT_SKY     1
#define AMBIENT_SLIME   2
#define AMBIENT_LAVA    3

#define NUM_AMBIENTS            4                  // automatic ambient sounds

// leaf 0 is the generic CONTENTS_SOLID leaf, used for all solid areas
// all other leafs need visibility info
typedef struct
{
    int             contents;
    int             visofs;                                // -1 = no visibility info

    Int32           mins[3];                               // for frustum culling
    Int32           maxs[3];

    unsigned int  firstmarksurface;
    unsigned int  nummarksurfaces;

    byte            ambient_level[NUM_AMBIENTS];
}
dleaf_t;

//============================================================================

#define ANGLE_UP    -1.0 //#define ANGLE_UP    -1 //--vluzacn
#define ANGLE_DOWN  -2.0 //#define ANGLE_DOWN  -2 //--vluzacn

//
// BSP File Data
//

extern int      g_nummodels;
extern dmodel_t g_dmodels[MAX_MAP_MODELS];
extern int      g_dmodels_checksum;

extern int      g_visdatasize;
extern byte     g_dvisdata[MAX_MAP_VISIBILITY];
extern int      g_dvisdata_checksum;

extern int      g_lightdatasize;
extern byte*    g_dlightdata;
extern int      g_dlightdata_checksum;

extern int      g_texdatasize;
extern byte*    g_dtexdata;                                  // (dmiptexlump_t)
extern int      g_dtexdata_checksum;

extern int      g_entdatasize;
extern char     g_dentdata[MAX_MAP_ENTSTRING];
extern int      g_dentdata_checksum;

extern int      g_numleafs;
extern dleaf_t  g_dleafs[MAX_MAP_LEAFS];
extern int      g_dleafs_checksum;

extern int      g_numplanes;
extern dplane_t g_dplanes[MAX_INTERNAL_MAP_PLANES];
extern int      g_dplanes_checksum;

extern int      g_numvertexes;
extern dvertex_t g_dvertexes[MAX_MAP_VERTS];
extern int      g_dvertexes_checksum;

extern int      g_numnodes;
extern dnode_t  g_dnodes[MAX_MAP_NODES];
extern int      g_dnodes_checksum;

extern int      g_numtexinfo;
extern texinfo_t g_texinfo[MAX_MAP_TEXINFO];
extern int      g_texinfo_checksum;

extern int      g_numfaces;
extern dface_t  g_dfaces[MAX_MAP_FACES];
extern int      g_dfaces_checksum;

extern int      g_numclipnodes;
extern dclipnode_t g_dclipnodes[MAX_MAP_CLIPNODES];
extern int      g_dclipnodes_checksum;

extern int      g_numedges;
extern dedge_t  g_dedges[MAX_MAP_EDGES];
extern int      g_dedges_checksum;

extern int      g_nummarksurfaces;
extern unsigned int g_dmarksurfaces[MAX_MAP_MARKSURFACES];
extern int      g_dmarksurfaces_checksum;

extern int      g_numsurfedges;
extern int      g_dsurfedges[MAX_MAP_SURFEDGES];
extern int      g_dsurfedges_checksum;

extern void     DecompressVis(const byte* src, byte* const dest, const unsigned int dest_length);
extern int      CompressVis(const byte* const src, const unsigned int src_length, byte* dest, unsigned int dest_length);

extern void     LoadBSPImage(dheader_t* header);
extern void     LoadBSPFile(const char* const filename);
extern void     WriteBSPFile(const char* const filename);
extern void     PrintBSPFileSizes();
#ifdef PLATFORM_CAN_CALC_EXTENT
extern void		WriteExtentFile (const char *const filename);
extern bool		CalcFaceExtents_test ();
#else
extern void		LoadExtentFile (const char *const filename);
#endif
extern void		GetFaceExtents (int facenum, int mins_out[2], int maxs_out[2]);
extern int		ParseImplicitTexinfoFromTexture (int miptex);
extern int		ParseTexinfoForFace (const dface_t *f);
extern void		DeleteEmbeddedLightmaps ();

//
// Entity Related Stuff
//

typedef struct epair_s
{
    struct epair_s* next;
    char*           key;
    char*           value;
}
epair_t;

typedef struct
{
    vec3_t          origin;
    int             firstbrush;
    int             numbrushes;
    epair_t*        epairs;
}
entity_t;

extern int      g_numentities;
extern entity_t g_entities[MAX_MAP_ENTITIES];

extern void            ParseEntities();
extern void            UnparseEntities();

extern void            DeleteKey(entity_t* ent, const char* const key);
extern void            SetKeyValue(entity_t* ent, const char* const key, const char* const value);
extern const char*     ValueForKey(const entity_t* const ent, const char* const key);
extern int             IntForKey(const entity_t* const ent, const char* const key);
extern vec_t           FloatForKey(const entity_t* const ent, const char* const key);
extern void            GetVectorForKey(const entity_t* const ent, const char* const key, vec3_t vec);

extern entity_t* FindTargetEntity(const char* const target);
extern epair_t* ParseEpair();
extern entity_t* EntityForModel(int modnum);

//
// Texture Related Stuff
//

extern int      g_max_map_miptex;
extern int		g_max_map_lightdata;
extern void     dtexdata_init();
extern void CDECL dtexdata_free();

extern char*    GetTextureByNumber(int texturenumber);

#endif //BSPFILE_H__
