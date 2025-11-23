#!/bin/bash
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
source tests-common.sh || exit

inherit toolchain-funcs

#
# TEST: tc-arch-kernel
#
test-tc-arch-kernel() {
	local ret=0
	KV=$1 ; shift
	for CHOST in "$@" ; do
		exp=${CHOST##*:}
		CHOST=${CHOST%%:*}
		actual=$(tc-arch-kernel)

		if [[ ${actual} != ${exp:-${CHOST}} ]] ; then
			eerror "Failure for CHOST: ${CHOST} Expected: ${exp} != Actual: ${actual}"
			((++ret))
		fi
	done
	return ${ret}
}
tbegin "tc-arch-kernel() (KV=2.6.30)"
test-tc-arch-kernel 2.6.30 \
	i{3..6}86:x86 x86_64:x86 \
	powerpc{,64}:powerpc \
	or1k:openrisc or1k-linux-musl:openrisc
tend $?

#
# TEST: tc-arch
#
tbegin "tc-arch"
ret=0
for CHOST in \
	alpha arm{,eb}:arm avr32:avr bfin cris hppa i{3..6}86:x86 ia64 m68k \
	mips{,eb}:mips nios2 powerpc:ppc powerpc64:ppc64 s390{,x}:s390 \
	sh{1..4}{,eb}:sh sparc{,64}:sparc vax x86_64:amd64
do
	exp=${CHOST##*:}
	CHOST=${CHOST%%:*}
	actual=$(tc-arch)

	if [[ ${actual} != ${exp:-${CHOST}} ]] ; then
		eerror "Failure for CHOST: ${CHOST} Expected: ${exp} != Actual: ${actual}"
		: $((++ret))
	fi
done
tend ${ret}

#
# TEST: tc-ld-is-gold
#
tbegin "tc-ld-is-gold (ld=bfd cc=bfd)"
LD=ld.bfd LDFLAGS=-fuse-ld=bfd tc-ld-is-gold && ret=1 || ret=0
tend ${ret}

if type -P ld.gold &>/dev/null; then
	tbegin "tc-ld-is-gold (ld=gold cc=default)"
	LD=ld.gold tc-ld-is-gold
	ret=$?
	tend ${ret}

	tbegin "tc-ld-is-gold (ld=gold cc=bfd)"
	LD=ld.gold LDFLAGS=-fuse-ld=bfd tc-ld-is-gold
	ret=$?
	tend ${ret}

	tbegin "tc-ld-is-gold (ld=bfd cc=gold)"
	LD=ld.bfd LDFLAGS=-fuse-ld=gold tc-ld-is-gold
	ret=$?
	tend ${ret}
fi

#
# TEST: tc-ld-disable-gold
#
tbegin "tc-ld-disable-gold (bfd selected)"
(
export LD=ld.bfd LDFLAGS=-fuse-ld=bfd
ewarn() { :; }
tc-ld-disable-gold
[[ ${LD} == "ld.bfd" && ${LDFLAGS} == "-fuse-ld=bfd" ]]
)
tend $?

if type -P ld.gold &>/dev/null; then
	tbegin "tc-ld-disable-gold (ld=gold)"
	(
	export LD=ld.gold LDFLAGS=
	ewarn() { :; }
	tc-ld-disable-gold
	[[ ${LD} == "ld.bfd" || ${LDFLAGS} == *"-fuse-ld=bfd"* ]]
	)
	tend $?

	tbegin "tc-ld-disable-gold (cc=gold)"
	(
	export LD= LDFLAGS="-fuse-ld=gold"
	ewarn() { :; }
	tc-ld-disable-gold
	[[ ${LD} == *"/ld.bfd" || ${LDFLAGS} == "-fuse-ld=gold -fuse-ld=bfd" ]]
	)
	tend $?
fi

unset CPP

tbegin "tc-get-compiler-type (gcc)"
(
export CC=gcc
[[ $(tc-get-compiler-type) == gcc ]]
)
tend $?

tbegin "tc-is-gcc (gcc)"
(
export CC=gcc
tc-is-gcc
)
tend $?

tbegin "! tc-is-clang (gcc)"
(
export CC=gcc
! tc-is-clang
)
tend $?

if type -P clang &>/dev/null; then
	tbegin "tc-get-compiler-type (clang)"
	(
	export CC=clang
	[[ $(tc-get-compiler-type) == clang ]]
	)
	tend $?

	tbegin "! tc-is-gcc (clang)"
	(
	export CC=clang
	! tc-is-gcc
	)
	tend $?

	tbegin "tc-is-clang (clang)"
	(
	export CC=clang
	tc-is-clang
	)
	tend $?
fi

if type -P pathcc &>/dev/null; then
	tbegin "tc-get-compiler-type (pathcc)"
	(
	export CC=pathcc
	[[ $(tc-get-compiler-type) == pathcc ]]
	)
	tend $?

	tbegin "! tc-is-gcc (pathcc)"
	(
	export CC=pathcc
	! tc-is-gcc
	)
	tend $?

	tbegin "! tc-is-clang (pathcc)"
	(
	export CC=pathcc
	! tc-is-clang
	)
	tend $?
fi

for compiler in gcc clang not-really-a-compiler; do
	if type -P ${compiler} &>/dev/null; then
		tbegin "tc-cpp-is-true ($compiler, defined)"
		(
			export CC=${compiler}
			tc-cpp-is-true "defined(SOME_DEFINED_SYMBOL)" -DSOME_DEFINED_SYMBOL
		)
		tend $?
		tbegin "tc-cpp-is-true ($compiler, not defined)"
		(
			export CC=${compiler}
			! tc-cpp-is-true "defined(SOME_UNDEFINED_SYMBOL)"
		)
		tend $?

		tbegin "tc-cpp-is-true ($compiler, defined on -ggdb3)"
		(
			export CC=${compiler}
			tc-cpp-is-true "defined(SOME_DEFINED_SYMBOL)" -DSOME_DEFINED_SYMBOL -ggdb3
		)
		tend $?
	fi
done

if type -P gcc &>/dev/null; then
	tbegin "tc-get-cxx-stdlib (gcc)"
	[[ $(CXX=g++ tc-get-cxx-stdlib) == libstdc++ ]]
	tend $?

	tbegin "tc-get-c-rtlib (gcc)"
	[[ $(CC=gcc tc-get-c-rtlib) == libgcc ]]
	tend $?

	tbegin "tc-is-lto (gcc, -fno-lto)"
	CC=gcc CFLAGS=-fno-lto tc-is-lto
	[[ $? -eq 1 ]]
	tend $?

	tbegin "tc-is-lto (gcc, -flto)"
	CC=gcc CFLAGS=-flto tc-is-lto
	[[ $? -eq 0 ]]
	tend $?

	case $(gcc -dumpmachine) in
		i*86*-gnu*|arm*-gnu*|powerpc-*-gnu)
			tbegin "tc-has-64bit-time_t (_TIME_BITS=32)"
			CC=gcc CFLAGS="-U_TIME_BITS -D_TIME_BITS=32" tc-has-64bit-time_t
			[[ $? -eq 1 ]]
			tend $?

			tbegin "tc-has-64bit-time_t (_TIME_BITS=64)"
			CC=gcc CFLAGS="-U_FILE_OFFSET_BITS -U_TIME_BITS -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64" tc-has-64bit-time_t
			[[ $? -eq 0 ]]
			tend $?
			;;
		*)
			tbegin "tc-has-64bit-time_t"
			CC=gcc tc-has-64bit-time_t
			[[ $? -eq 0 ]]
			tend $?
			;;
	esac
fi

if type -P clang &>/dev/null; then
	for stdlib in libc++ libstdc++; do
		if clang++ -stdlib=${stdlib} -x c++ -E -P - &>/dev/null \
			<<<'#include <ciso646>'
		then
			tbegin "tc-get-cxx-stdlib (clang, ${stdlib})"
			[[ $(CXX=clang++ CXXFLAGS="-stdlib=${stdlib}" tc-get-cxx-stdlib) == ${stdlib} ]]
			tend $?
		fi
	done

	tbegin "tc-get-cxx-stdlib (clang, invalid)"
	! CXX=clang++ CXXFLAGS="-stdlib=invalid" tc-get-cxx-stdlib
	tend $?

	for rtlib in compiler-rt libgcc; do
		tbegin "tc-get-c-rtlib (clang, ${rtlib})"
		[[ $(CC=clang CFLAGS="--rtlib=${rtlib}" tc-get-c-rtlib) == ${rtlib} ]]
		tend $?
	done

	tbegin "tc-is-lto (clang, -fno-lto)"
	CC=clang CFLAGS=-fno-lto tc-is-lto
	[[ $? -eq 1 ]]
	tend $?

	tbegin "tc-is-lto (clang, -flto)"
	CC=clang CFLAGS=-flto tc-is-lto
	[[ $? -eq 0 ]]
	tend $?
fi

texit
