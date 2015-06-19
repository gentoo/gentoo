#!/usr/bin/make -f
# -*- mode: makefile; indent-tabs-mode: t -*- vim:noet:ts=4
# Sample Makefile for lexicon generation and installation.

# Little endian platforms: alpha amd64 arm hurd-i386 i386 ia64 mipsel sh3 sh4
# Big endian platforms: hppa m68k mips powerpc ppc64 sparc s390
ifndef ENDIANNESS
	ENDIANNESS = le
endif

DICT_FILE = dict.utf8

SLM_TARGET = lm_sc
TSLM2_TEXT_FILE = ${SLM_TARGET}.t2g.arpa
TSLM2_ORIG_FILE = ${SLM_TARGET}.t2g.orig
TSLM2_DIST_FILE = ${SLM_TARGET}.t2g
TSLM3_TEXT_FILE = ${SLM_TARGET}.t3g.arpa
TSLM3_ORIG_FILE = ${SLM_TARGET}.t3g.orig
TSLM3_DIST_FILE = ${SLM_TARGET}.t3g

PYTRIE_FILE = pydict_sc.bin
PYTRIE_LOG_FILE = pydict_sc.log

SYSTEM_DATA_DIR = ${DESTDIR}/usr/share/sunpinyin

all: slm3_dist
install: slm3_install

tslm2_orig: ${TSLM2_ORIG_FILE}
${TSLM2_ORIG_FILE}: ${DICT_FILE} ${TSLM2_TEXT_FILE}
	tslmpack ${TSLM2_TEXT_FILE} ${DICT_FILE} $@

tslm2_dist: ${TSLM2_DIST_FILE}
${TSLM2_DIST_FILE}: ${TSLM2_ORIG_FILE}
	tslmendian -e ${ENDIANNESS} -i $^ -o $@

lexicon2: ${DICT_FILE} ${TSLM2_ORIG_FILE}
	genpyt -e ${ENDIANNESS} -i ${DICT_FILE} -s ${TSLM2_ORIG_FILE} \
		-l ${PYTRIE_LOG_FILE} -o ${PYTRIE_FILE}

tslm3_orig: ${TSLM3_ORIG_FILE}
${TSLM3_ORIG_FILE}: ${DICT_FILE} ${TSLM3_TEXT_FILE}
	tslmpack ${TSLM3_TEXT_FILE} ${DICT_FILE} $@

tslm3_dist: ${TSLM3_DIST_FILE}
${TSLM3_DIST_FILE}: ${TSLM3_ORIG_FILE}
	tslmendian -e ${ENDIANNESS} -i $^ -o $@

lexicon3: ${DICT_FILE} ${TSLM3_ORIG_FILE}
	genpyt -e ${ENDIANNESS} -i ${DICT_FILE} -s ${TSLM3_ORIG_FILE} \
		-l ${PYTRIE_LOG_FILE} -o ${PYTRIE_FILE}

slm2_dist: ${TSLM2_DIST_FILE} lexicon2
slm2_install: ${TSLM2_DIST_FILE} ${PYTRIE_FILE}
	install -d ${SYSTEM_DATA_DIR}
	install -Dm644 $^ ${SYSTEM_DATA_DIR}

slm3_dist: ${TSLM3_DIST_FILE} lexicon3
slm3_install: ${TSLM3_DIST_FILE} ${PYTRIE_FILE}
	install -d ${SYSTEM_DATA_DIR}
	install -Dm644 $^ ${SYSTEM_DATA_DIR}

