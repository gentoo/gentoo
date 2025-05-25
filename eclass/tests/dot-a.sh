#!/bin/bash
# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

source tests-common.sh || exit
source version-funcs.sh || exit

inherit dot-a

_create_test_progs() {
	cat <<-EOF > a.c
	int foo();

	int foo() {
		return 42;
	}
	EOF

	cat <<-EOF > main.c
	#include <stdio.h>
	int foo();

	int main() {
		printf("Got magic number: %d\n", foo());
		return 0;
	}
	EOF
}

test_lto_guarantee_fat() {
	# Check whether lto-guarantee-fat adds -ffat-lto-objects and it
	# results in a successful link (and a failed link without it).
	LDFLAGS="-fuse-ld=${linker}"

	$(tc-getCC) ${CFLAGS} -flto a.c -o a.o -c || die
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -flto main.c a.o -o main || die
	if ./main | grep -q "Got magic number: 42" ; then
		:;
	else
		die "Pure LTO check failed"
	fi

	tbegin "lto-guarantee-fat (CC=$(tc-getCC), linker=${linker}): check linking w/ fat LTO object w LTO"
	ret=0
	(
		export CFLAGS="-O2 -flto"
		lto-guarantee-fat

		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getCC) ${CFLAGS} ${LDFLAGS} main.c a.o 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Linking LTO executable w/ fat object failed"

	tbegin "lto-guarantee-fat (CC=$(tc-getCC), linker=${linker}): check linking w/ fat LTO object w/o LTO"
	ret=0
	(
		export CFLAGS="-O2 -flto"
		lto-guarantee-fat

		# Linking here will fail if a.o isn't a fat object, as there's nothing
		# to fall back on with -fno-lto.
		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fno-lto main.c a.o 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Linking non-LTO executable w/ fat object failed"

	tbegin "lto-guarantee-fat (CC=$(tc-getCC), linker=${linker}): check linking w/ fat LTO archive w LTO"
	ret=0
	(
		export CFLAGS="-O2 -flto"
		lto-guarantee-fat

		rm test.a 2>/dev/null

		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getAR) r test.a a.o 2>/dev/null || return 1
		$(tc-getCC) ${CFLAGS} ${LDFLAGS} main.c test.a 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Linking LTO executable w/ fat archive failed"

	tbegin "lto-guarantee-fat (CC=$(tc-getCC), linker=${linker}): check linking w/ fat LTO archive w/o LTO"
	ret=0
	(
		export CFLAGS="-O2 -flto"
		lto-guarantee-fat

		rm test.a 2>/dev/null

		# Linking here will fail if a.o (-> test.a) isn't a fat object, as there's nothing
		# to fall back on with -fno-lto.
		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getAR) r test.a a.o 2>/dev/null || return 1
		$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fno-lto main.c test.a 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Linking non-LTO executable w/ fat archive failed"
}

test_strip_lto_bytecode() {
	# Check whether strip-lto-bytecode does its job on a single argument, but
	# focus of this test is more basic, not checking all possible option
	# handling.
	#
	# i.e. If we use strip-lto-bytecode, does it remove the LTO bytecode
	# and allow linking? If we use it w/o -ffat-lto-objects, do we get
	# a failed link as we expect?
	LDFLAGS="-fuse-ld=${linker}"

	tbegin "strip-lto-bytecode (CC=$(tc-getCC), linker=${linker}): check that linking w/ stripped non-fat object breaks"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		# strip-lto-bytecode will error out early with LLVM,
		# so stop the test here.
		tc-is-clang && return 0

		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1

		# This should corrupt a.o and make linking below fail.
		strip-lto-bytecode a.o

		$(tc-getCC) ${CFLAGS} ${LDFLAGS} main.c a.o -o main 2>/dev/null && return 1

		return 0
	) || ret=1
	tend ${ret} "Linking corrupted non-fat object unexpectedly worked"

	tbegin "strip-lto-bytecode (CC=$(tc-getCC), linker=${linker}): check that linking w/ stripped fat object works"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		lto-guarantee-fat

		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1

		# This should NOT corrupt a.o, so linking below should succeed.
		strip-lto-bytecode a.o

		$(tc-getCC) ${CFLAGS} ${LDFLAGS} main.c a.o -o main 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Linking stripped fat object failed"

	tbegin "strip-lto-bytecode (CC=$(tc-getCC), linker=${linker}): check that linking w/ stripped non-fat archive breaks"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		rm test.a 2>/dev/null

		# strip-lto-bytecode will error out early with LLVM,
		# so stop the test here.
		tc-is-clang && return 0

		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getAR) q test.a a.o 2>/dev/null || return 1

		# This should corrupt a.o and make linking below fail.
		strip-lto-bytecode test.a

		$(tc-getCC) ${CFLAGS} ${LDFLAGS} main.c test.a -o main 2>/dev/null && return 1

		return 0
	) || ret=1
	tend ${ret} "Linking corrupted non-fat object unexpectedly worked"

	tbegin "strip-lto-bytecode (CC=$(tc-getCC), linker=${linker}): check that linking w/ stripped fat archive works"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		rm test.a 2>/dev/null

		lto-guarantee-fat

		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getAR) q test.a a.o 2>/dev/null || return 1

		# This should NOT corrupt a.o, so linking below should succeed.
		strip-lto-bytecode test.a

		$(tc-getCC) ${CFLAGS} ${LDFLAGS} main.c test.a -o main 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Linking stripped fat archive failed"
}

test_mixed_objects_after_stripping() {
	# Check whether mixing objects from two compilers (${CC_1} and ${CC_2})
	# fails without lto-guarantee-fat and strip-lto-bytecode and works
	# once they're used.
	LDFLAGS="-fuse-ld=${linker}"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that unstripped LTO objects from ${CC_1} fail w/ ${CC_2}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		${CC_1} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		# Using CC_1 IR with CC_2 should fail.
		${CC_2} ${CFLAGS} ${LDFLAGS} main.c a.o -o main 2>/dev/null && return 1

		return 0
	) || ret=1
	tend ${ret} "Mixing unstripped objects unexpectedly worked"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that unstripped LTO objects from ${CC_2} fail w/ ${CC_1}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		${CC_2} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		# Using CC_2 IR with CC_1 should fail.
		${CC_1} ${CFLAGS} ${LDFLAGS} main.c a.o -o main 2>/dev/null && return 1

		return 0
	) || ret=1
	tend ${ret} "Mixing unstripped objects unexpectedly worked"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that stripped LTO objects from ${CC_1} work w/ ${CC_2}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		lto-guarantee-fat
		${CC_1} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		# The object should now be "vendor-neutral" and work.
		CC=${CC_1} strip-lto-bytecode a.o
		${CC_2} ${CFLAGS} ${LDFLAGS} main.c a.o -o main 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Mixing stripped objects failed"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that stripped LTO objects from ${CC_2} work w/ ${CC_1}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		lto-guarantee-fat
		${CC_2} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		# The object should now be "vendor-neutral" and work.
		CC=${CC_2} strip-lto-bytecode a.o
		${CC_1} ${CFLAGS} ${LDFLAGS} main.c a.o -o main 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Mixing stripped objects failed"
}

test_mixed_archives_after_stripping() {
	# Check whether mixing archives from two compilers (${CC_1} and ${CC_2})
	# fails without lto-guarantee-fat and strip-lto-bytecode and works
	# once they're used.
	LDFLAGS="-fuse-ld=${linker}"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that unstripped LTO archives from ${CC_1} fail w/ ${CC_2}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		rm test.a 2>/dev/null

		${CC_1} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		${AR_1} r test.a a.o 2>/dev/null || return 1
		# Using CC_1 IR with CC_2 should fail.
		${CC_2} ${CFLAGS} ${LDFLAGS} main.c test.a -o main 2>/dev/null && return 1

		return 0
	) || ret=1
	tend ${ret} "Mixing unstripped archives unexpectedly worked"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that unstripped LTO archives from ${CC_2} fail w/ ${CC_1}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		rm test.a 2>/dev/null

		${CC_2} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		${AR_2} r test.a a.o 2>/dev/null || return 1
		# Using CC_2 IR with CC_1 should fail.
		${CC_1} ${CFLAGS} ${LDFLAGS} main.c test.a -o main 2>/dev/null && return 1

		return 0
	) || ret=1
	tend ${ret} "Mixing unstripped archives unexpectedly worked"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that stripped LTO archives from ${CC_1} work w/ ${CC_2}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		rm test.a 2>/dev/null

		lto-guarantee-fat
		${CC_1} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		${AR_1} r test.a a.o 2>/dev/null || return 1
		# The object should now be "vendor-neutral" and work.
		CC=${CC_1} strip-lto-bytecode test.a
		${CC_2} ${CFLAGS} ${LDFLAGS} main.c test.a -o main 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Mixing stripped archives failed"

	tbegin "strip-lto-bytecode (CC_1=${CC_1}, CC_2=${CC_2}, linker=${linker}): check that stripped LTO archives from ${CC_2} work w/ ${CC_1}"
	ret=0
	(
		export CFLAGS="-O2 -flto"

		rm test.a 2>/dev/null

		lto-guarantee-fat
		${CC_2} ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		${AR_2} r test.a a.o 2>/dev/null || return 1
		# The object should now be "vendor-neutral" and work.
		CC=${CC_2} strip-lto-bytecode test.a
		${CC_1} ${CFLAGS} ${LDFLAGS} main.c test.a -o main 2>/dev/null || return 1
	) || ret=1
	tend ${ret} "Mixing stripped archives failed"
}

_check_if_lto_object() {
	# Adapted from tc-is-lto
	local ret=1
	case $(tc-get-compiler-type) in
		clang)
			# If LTO is used, clang will output bytecode and llvm-bcanalyzer
			# will run successfully.  Otherwise, it will output plain object
			# file and llvm-bcanalyzer will exit with error.
			llvm-bcanalyzer "$1" &>/dev/null && ret=0
			;;
		gcc)
			[[ $($(tc-getREADELF) -S "$1") == *.gnu.lto* ]] && ret=0
			;;
	esac
	return "${ret}"
}

test_search_recursion() {
	# Test whether the argument handling and logic of strip-lto-bytecode
	# works as expected.
	tbegin "whether default search behaviour of \${ED} works"
	ret=0
	(
		CC=gcc
		CFLAGS="-O2 -flto"

		rm foo.a 2>/dev/null

		_create_test_progs
		lto-guarantee-fat
		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getAR) q foo.a a.o 2>/dev/null || return 1

		_check_if_lto_object "${tmpdir}/lto/foo.a" || return 1
		# It should search ${ED} if no arguments are passed, find
		# the LTO'd foo.o, and strip it.
		ED="${tmpdir}/lto" strip-lto-bytecode
		# foo.a should be a regular object here.
		_check_if_lto_object "${tmpdir}/lto/foo.a" && return 1

		return 0
	) || ret=1
	tend ${ret} "Unexpected LTO object found"

	tbegin "whether a single file argument works"
	ret=0
	(
		CC=gcc
		CFLAGS="-O2 -flto"

		rm foo.a 2>/dev/null

		_create_test_progs
		lto-guarantee-fat
		$(tc-getCC) ${CFLAGS} a.c -o a.o -c 2>/dev/null || return 1
		$(tc-getAR) r foo.a a.o 2>/dev/null || return 1

		_check_if_lto_object "${tmpdir}/lto/foo.a" || return 1
		# It should search ${ED} if no arguments are passed, find
		# the LTO'd foo.o, and strip it.
		ED="${tmpdir}/lto" strip-lto-bytecode "${tmpdir}/lto/foo.a"
		# foo.a should be a regular object here.
		_check_if_lto_object "${tmpdir}/lto/foo.a" && return 1

		return 0
	) || ret=1
	tend ${ret} "Unexpected LTO object found"

	tbegin "whether a directory and file argument works"
	ret=0
	(
		mkdir "${tmpdir}"/lto2 || die

		CC=gcc
		CFLAGS="-O2 -flto"

		rm foo.a 2>/dev/null

		_create_test_progs
		lto-guarantee-fat
		$(tc-getCC) ${CFLAGS} "${tmpdir}"/lto/a.c -o "${tmpdir}"/lto/a.o -c 2>/dev/null || return 1
		$(tc-getAR) q foo.a a.o 2>/dev/null || return 1
		$(tc-getAR) q "${tmpdir}"/lto2/foo.a a.o 2>/dev/null || return 1

		_check_if_lto_object "${tmpdir}/lto/foo.a" || return 1
		_check_if_lto_object "${tmpdir}/lto2/foo.a" || return 1
		# It should search ${ED} if no arguments are passed, find
		# the LTO'd foo.o, and strip it.
		ED="${tmpdir}/lto" strip-lto-bytecode "${tmpdir}/lto/foo.a" "${tmpdir}/lto2/foo.a"
		# foo.a should be a regular object here.
		_check_if_lto_object "${tmpdir}/lto/foo.a" && return 1
		_check_if_lto_object "${tmpdir}/lto2/foo.a" && return 1

		return 0
	) || ret=1
	tend ${ret} "Unexpected LTO object found"
}

_repeat_tests_with_compilers() {
	# Call test_lto_guarantee_fat and test_strip_lto_bytecode with
	# various compilers and linkers.
	for toolchain in gcc:ar clang:llvm-ar ; do
		CC=${toolchain%:*}
		AR=${toolchain#*:}
		type -P ${CC} &>/dev/null || continue
		type -P ${AR} &>/dev/null || continue

		for linker in gold bfd lld mold gold ; do
			# lld doesn't support GCC LTO: https://github.com/llvm/llvm-project/issues/41791
			[[ ${CC} == gcc && ${linker} == lld ]] && continue
			# Make sure the relevant linker is actually installed and usable.
			LDFLAGS="-fuse-ld=${linker}" tc-ld-is-${linker} || continue
			LDFLAGS="-fuse-ld=${linker}" test-compile 'c+ld' 'int main() { return 0; }' || continue

			test_lto_guarantee_fat
			test_strip_lto_bytecode
		done
	done
}

_repeat_mixed_tests_with_linkers() {
	# Call test_mixed_objects_after_stripping with various linkers.
	#
	# Needs both GCC and Clang to test mixing their outputs.
	if type -P gcc &>/dev/null && type -P clang &>/dev/null ; then
		for linker in bfd lld mold gold ; do
			# lld doesn't support GCC LTO: https://github.com/llvm/llvm-project/issues/41791
			[[ ${CC} == gcc && ${linker} == lld ]] && continue
			# Make sure the relevant linker is actually installed and usable.
			LDFLAGS="-fuse-ld=${linker}" tc-ld-is-${linker} || continue
			LDFLAGS="-fuse-ld=${linker}" test-compile 'c+ld' 'int main() { return 0; }' || continue

			CC_1=gcc AR_1=ar
			CC_2=clang AR_2=llvm-ar
			test_mixed_objects_after_stripping
			test_mixed_archives_after_stripping
		done
	fi
}

# TODO: maybe test several files
mkdir -p "${tmpdir}/lto" || die
pushd "${tmpdir}/lto" >/dev/null || die
_create_test_progs
_repeat_tests_with_compilers
_repeat_mixed_tests_with_linkers
test_search_recursion
texit
