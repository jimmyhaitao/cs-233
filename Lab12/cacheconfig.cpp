#include "cacheconfig.h"
#include "utils.h"

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 
	_num_block_offset_bits=0;	
	_num_index_bits=0;
	_num_tag_bits=32;
	if(block_size==0||associativity==0)return;
	uint32_t blocknum=size/block_size;
	uint32_t setnum=blocknum/associativity;
	for(uint32_t i = block_size;i!=1;i=i/2){
		_num_block_offset_bits++;
	}
	for(uint32_t i = setnum;i!=1;i=i/2){
		_num_index_bits++;
	}
	_num_tag_bits=_num_tag_bits-_num_block_offset_bits-_num_index_bits;
	return;	
}



