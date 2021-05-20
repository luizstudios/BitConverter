#pragma once

#include <stdbool.h>
#include <inttypes.h>
#include <stddef.h>

bool is_little_endian();
bool array_is_secure(const void *input, const uint32_t offset, const size_t array_size);

int16_t bytes_to_int16(const uint8_t input[], const size_t array_size, uint32_t offset);
uint16_t bytes_to_uint16(const uint8_t input[], const size_t array_size, uint32_t offset);

int32_t bytes_to_int32(const uint8_t input[], const size_t array_size, uint32_t offset);
uint32_t bytes_to_uint32(const uint8_t input[], const size_t array_size, uint32_t offset);

int64_t bytes_to_int64(const uint8_t input[], const size_t array_size, uint32_t offset);
uint64_t bytes_to_uint64(const uint8_t input[], const size_t array_size, uint32_t offset);
