#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

extern object *objalloc();

object* getSlot(object *self, char *slot, int followChain)
{
	printf ("Getting slot for %s\n", slot);
	object *obj = self;
	while (obj) {
		printf("obj %d\n", obj);
		slotmap::iterator it = obj->slots->find(slot);
		if (it == obj->slots->end()) {
			if (followChain) { obj = obj->prototype; continue; }
			else return NULL;
		}
		printf("Found slot %d\n", (*it).second);
		return (*it).second;
	}
	return NULL;
}

void putSlot(object *self, char *slot, object *value)
{
	printf ("Putting slot for %s\n", slot);
	(*self->slots)[slot] = value;
}

object* newobj(object *prototype)
{
	object *obj = new object;
	object *init = getSlot(prototype, "init", 1);
	obj->prototype = prototype;
	obj->slots = new slotmap();
	return obj;
}

#ifdef __cplusplus
}
#endif