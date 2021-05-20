#include "bitconverter.h"
#include "logger.h"

bool is_little_endian()
{
	int n = 1;
	return (*(char *)&n == 1) ? true : false;
}

bool array_is_secure(const void *input, const uint32_t offset, const size_t array_size)
{
	if (input == NULL)
	{
		LOG("Error: \"Null input byte vector\"");

		return false;
	}

	if (array_size == 0)
	{
		LOG("Error: \"Empty byte array\"");

		return false;
	}

	if (offset >= array_size)
	{
		LOG("Error: \"Out of range\"");

		return false;
	}

	if (offset > (array_size - 4))
	{
		LOG("FATAL: Input byte vector is too small");

		return false;
	}

	return true;
}

int16_t bytes_to_int16(const uint8_t input[], const size_t array_size, uint32_t offset)
{
	if (array_is_secure(input, offset, array_size))
	{
		if (is_little_endian())
			return (input[offset]) | (input[offset + 1] << 8);
		else
			return (input[offset] << 8) | (input[offset]);
	}

	return 0;
}

uint16_t bytes_to_uint16(const uint8_t input[], const size_t array_size, uint32_t offset)
{
	int16_t int16 = bytes_to_int16(input, array_size, offset);
	if (int16 < 0)
		return 0;

	return int16;
}

int32_t bytes_to_int32(const uint8_t input[], const size_t array_size, uint32_t offset)
{
	if (array_is_secure(input, offset, array_size))
	{
		if (is_little_endian())
			return (input[offset]) | (input[offset + 1] << 8) | (input[offset + 2] << 16) | (input[offset + 3] << 24);
		else
			return (input[offset] << 24) | (input[offset] << 16) | (input[offset] << 8) | (input[offset]);
	}

	return 0;
}

uint32_t bytes_to_uint32(const uint8_t input[], const size_t array_size, uint32_t offset)
{
	int32_t int32 = bytes_to_int32(input, array_size, offset);
	if (int32 < 0)
		return 0;

	return int32;
}

int64_t bytes_to_int64(const uint8_t input[], const size_t array_size, uint32_t offset)
{
	int64_t first = 0, second = 0;

	if (array_is_secure(input, array_size, offset))
	{
		if (is_little_endian())
		{
			first = (input[offset]) | (input[offset + 1] << 8) | (input[offset + 2] << 16) | (input[offset + 3] << 24);
			second = (input[offset + 4]) | (input[offset + 5] << 8) | (input[offset + 6] << 16) | (input[offset + 7] << 24);

			return (int64_t)((int64_t)first | ((int64_t)second << 32));
		}
		else
		{
			first = (input[offset] << 24) | (input[offset + 1] << 16) | (input[offset + 2] << 8) | (input[offset + 3]);
			second = (input[offset + 4] << 24) | (input[offset + 5] << 16) | (input[offset + 6] << 8) | (input[offset + 7]);

			return (int64_t)((int64_t)second | ((int64_t)first << 32));
		}
	}

	return 0;
}

uint64_t bytes_to_uint64(const uint8_t input[], const size_t array_size, uint32_t offset)
{
	int64_t int64 = bytes_to_int64(input, array_size, offset);
	if (int64 < 0)
		return 0;

	return int64;
}