#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  	int offB=_cache_config.get_num_block_offset_bits();
  	int indexB=_cache_config.get_num_index_bits();
  	//uint32_t tagB=_cache_config.get_num_tag_bits();
  	uint32_t result=0;
  	result=((get_tag()<<indexB)+_index)<<offB;
  	
  return result;
}
