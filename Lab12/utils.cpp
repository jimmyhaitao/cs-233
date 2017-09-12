#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
 	uint32_t offB=cache_config.get_num_block_offset_bits();
  	uint32_t indexB=cache_config.get_num_index_bits();
  	uint32_t tagB=cache_config.get_num_tag_bits();
  	if(tagB>=32)return address;
	uint32_t result= address>>(offB+indexB);
  return result;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  	uint32_t offB=cache_config.get_num_block_offset_bits();
  	//uint32_t indexB=cache_config.get_num_index_bits();
  	uint32_t tagB=cache_config.get_num_tag_bits();
  	if(tagB>=32)return 0;
  	uint32_t result=((address<<tagB)>>(tagB+offB));
  return result;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  	//uint32_t offB=cache_config.get_num_block_offset_bits();
  	uint32_t indexB=cache_config.get_num_index_bits();
  	uint32_t tagB=cache_config.get_num_tag_bits();
  	if(tagB>=32)return 0;
  	uint32_t result=((address<<(tagB+indexB))>>(tagB+indexB));
  return result;
}
