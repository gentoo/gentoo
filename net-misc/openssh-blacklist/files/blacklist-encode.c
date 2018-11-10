/*
 * The blacklist encoder for RSA/DSA key blacklisting based on partial
 * fingerprints,
 * developed under Openwall Project for Owl - http://www.openwall.com/Owl/
 *
 * Copyright (c) 2008 Dmitry V. Levin <ldv at cvs.openwall.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * The blacklist encoding was designed by Solar Designer and Dmitry V. Levin.
 * No intellectual property rights to the encoding scheme are claimed.
 *
 * This effort was supported by CivicActions - http://www.civicactions.com
 *
 * The file size to encode 294,903 of 48-bit fingerprints is just 1.3 MB,
 * which corresponds to less than 4.5 bytes per fingerprint.
 */

#ifndef _GNU_SOURCE
# define _GNU_SOURCE
#endif

#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <errno.h>
#include <error.h>
#include <limits.h>

static void *
xmalloc(size_t size)
{
	void   *r = malloc(size);

	if (!r)
		error(EXIT_FAILURE, errno, "malloc: allocating %lu bytes",
		      (unsigned long) size);
	return r;
}

static void *
xcalloc(size_t nmemb, size_t size)
{
	void   *r = calloc(nmemb, size);

	if (!r)
		error(EXIT_FAILURE, errno, "calloc: allocating %lu*%lu bytes",
		      (unsigned long) nmemb, (unsigned long) size);
	return r;
}

static void *
xrealloc(void *ptr, size_t nmemb, size_t elem_size)
{
	if (nmemb && ULONG_MAX / nmemb < elem_size)
		error(EXIT_FAILURE, 0, "realloc: nmemb*size > ULONG_MAX");

	size_t  size = nmemb * elem_size;
	void   *r = realloc(ptr, size);

	if (!r)
		error(EXIT_FAILURE, errno,
		      "realloc: allocating %lu*%lu bytes",
		      (unsigned long) nmemb, (unsigned long) elem_size);
	return r;
}

static char *
xstrdup(const char *s)
{
	size_t  len = strlen(s);
	char   *r = xmalloc(len + 1);

	memcpy(r, s, len + 1);
	return r;
}

static unsigned
c2u(uint8_t c)
{
	return (c >= 'a') ? (c - 'a' + 10) : (c - '0');
}

static char **records = NULL;
static unsigned records_count = 0;

static int
comparator(const void *p1, const void *p2)
{
	return strcmp(*(char *const *) p1, *(char *const *) p2);
}

static void
read_stream(FILE *fp, unsigned bytes)
{
	char   *line = NULL;
	unsigned size = 0, allocated = 0, len = bytes * 2;
	int     n;

	while ((n = getline(&line, &size, fp)) >= 0)
	{
		if (n > 0 && line[n - 1] == '\n')
			line[--n] = '\0';
		if (n < len || strspn(line, "0123456789abcdef") < n)
			continue;	/* ignore short or invalid lines */
		line[len] = '\0';

		if (!records)
			records = xcalloc(allocated = 1024, sizeof(*records));
		if (records_count >= allocated)
			records = xrealloc(records, allocated *= 2,
					   sizeof(*records));
		records[records_count++] = xstrdup(line);
	}
	free(line);
	records = xrealloc(records, records_count, sizeof(*records));
	if (records_count >= (1U << 24))
		error(EXIT_FAILURE, 0, "too many records: %u", records_count);

	qsort(records, records_count, sizeof(*records), comparator);
}

static void
print_uint8(FILE *fp, uint8_t v)
{
	fprintf(fp, "%c", v);
}

static void
print_uint16(FILE *fp, uint16_t v)
{
	fprintf(fp, "%c%c", v >> 8, v & 0xff);
}

static void
print_uint24(FILE *fp, uint32_t v)
{
	fprintf(fp, "%c%c%c", (v >> 16) & 0xff, (v >> 8) & 0xff, v & 0xff);
}

int
main(int ac, const char **av)
{
	unsigned count, i, record_bytes, first_index = 0, prev_index = 0;
	int     min_offset, max_offset;
	int    *offsets;

	if (ac < 2)
		error(EXIT_FAILURE, 0, "insufficient arguments");
	if (ac > 2)
		error(EXIT_FAILURE, 0, "too many arguments");
	record_bytes = atoi(av[1]);
	if (record_bytes < 6 || record_bytes > 16)
		error(EXIT_FAILURE, 0, "fingerprint size out of bounds");

	read_stream(stdin, record_bytes);

	/* initialize global records offset table */
	offsets = xcalloc(65536, sizeof(*offsets));
	for (count = 0; count < records_count; ++count, prev_index = i)
	{
		const char *r = records[count];

		i = (((((c2u(r[0]) << 4) + c2u(r[1])) << 4) +
		      c2u(r[2])) << 4) + c2u(r[3]);
		if (count == 0)
			first_index = i;
		else if (i == prev_index)
			continue;
		offsets[i] = count;
	}

	/* set offsets for indices without records */
	if (offsets[65536 - 1] == 0)
		offsets[65536 - 1] = records_count;
	for (i = 65536 - 2; i > first_index; --i)
		if (offsets[i] == 0)
			offsets[i] = offsets[i + 1];

	/* make global records offset table relative to
	   expected position assuming uniform distribution. */
	for (i = 0, min_offset = 0, max_offset = 0; i < 65536; ++i)
	{
		offsets[i] -= (i * (unsigned long long) records_count) >> 16;
		if (offsets[i] < min_offset)
			min_offset = offsets[i];
		if (offsets[i] > max_offset)
			max_offset = offsets[i];
	}
	min_offset = -min_offset;
	if (min_offset < 0)
		error(EXIT_FAILURE, 0,
		      "invalid offset shift: %d", min_offset);
	for (i = 0; i < 65536; ++i)
	{
		offsets[i] += min_offset;
		if (offsets[i] < 0 || offsets[i] >= 65536)
			error(EXIT_FAILURE, 0,
			      "offset overflow for index %#x: %d",
			      i, offsets[i]);
	}
	max_offset += min_offset;

	/* Header, 16 bytes */

	/* format version identifier */
	printf("SSH-FP00");
	/* index size, in bits */
	print_uint8(stdout, 16);
	/* offset size, in bits */
	print_uint8(stdout, 16);
	/* record size, in bits */
	print_uint8(stdout, record_bytes * 8);
	/* records count */
	print_uint24(stdout, records_count);
	/* offset shift */
	print_uint16(stdout, min_offset);
	fprintf(stderr, "records=%u, offset shift=%d, max offset=%d\n",
		records_count, min_offset, max_offset);

	/* Index, 65536 * 2 bytes */
	for (i = 0; i < 65536; ++i)
		print_uint16(stdout, offsets[i]);

	/* Fingerprints, records_count * (record_bytes-2) bytes */
	for (count = 0; count < records_count; ++count)
	{
		const char *r = records[count] + 4;

		for (i = 0; i < record_bytes - 2; ++i)
			print_uint8(stdout,
				    c2u(r[i * 2]) * 16 + c2u(r[i * 2 + 1]));
	}

	if (fclose(stdout))
		error(EXIT_FAILURE, errno, "stdout");
	return 0;
}
