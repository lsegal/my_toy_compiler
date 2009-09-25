#include <map>

#ifdef __cplusplus
extern "C" {
#endif

struct object;
typedef std::map<char*,object*> slotmap;

struct object {
	struct object *prototype;
	slotmap *slots;
};

struct cstring {
	struct object *prototype;
	slotmap *slots;
	char *ptr;
	size_t len;
};

struct cinteger {
	struct object *prototype;
	slotmap *slots;
	uint64_t value;
};

struct cdouble {
	struct object *prototype;
	slotmap *slots;
	double value;
};

#ifdef __cplusplus
}
#endif