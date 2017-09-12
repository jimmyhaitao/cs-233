#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
	auto it=_cache[index];
	for(auto it2 :it){
		if(it2.valid()&&it2.tag()==tag){
			return it2.get_byte(block_offset);
		}
	}
	return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
	auto it= &_cache[index];
	for(auto& it2:*it){
		if(!it2.valid()){
			it2.replace(tag,data);
			return;
		}
	}
	_cache[index][0].replace(tag,data);
}
