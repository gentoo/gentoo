#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

source tests-common.sh

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
tbegin "tc-arch-kernel() (KV=2.6.0)"
test-tc-arch-kernel 2.6.0 \
	alpha arm{,eb}:arm avr32 bfin:blackfin cris hppa:parisc \
	i{3..6}86:i386 ia64 m68k mips{,eb}:mips nios2 powerpc:ppc powerpc64:ppc64 \
	s390{,x}:s390 sh{1..4}{,eb}:sh sparc{,64} vax x86_64 \
	i{3..6}86-gentoo-freebsd:i386
tend $?
tbegin "tc-arch-kernel() (KV=2.6.30)"
test-tc-arch-kernel 2.6.30 \
	i{3..6}86:x86 x86_64:x86 \
	powerpc{,64}:powerpc i{3..6}86-gentoo-freebsd:i386
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
tbegin "tc-ld-is-gold (bfd selected)"
LD=ld.bfd tc-ld-is-gold && ret=1 || ret=0
tend ${ret}

tbegin "tc-ld-is-gold (gold selected)"
LD=ld.gold tc-ld-is-gold
ret=$?
tend ${ret}

tbegin "tc-ld-is-gold (bfd selected via flags)"
LD=ld.gold LDFLAGS=-fuse-ld=bfd tc-ld-is-gold
ret=$?
tend ${ret}

tbegin "tc-ld-is-gold (gold selected via flags)"
LD=ld.bfd LDFLAGS=-fuse-ld=gold tc-ld-is-gold
ret=$?
tend ${ret}

#
# TEST: tc-ld-disable-gold
#
tbegin "tc-ld-disable-gold (bfd selected)"
(
export LD=ld.bfd LDFLAGS=
ewarn() { :; }
tc-ld-disable-gold
[[ ${LD} == "ld.bfd" && -z ${LDFLAGS} ]]
)
tend $?

tbegin "tc-ld-disable-gold (gold selected)"
(
export LD=ld.gold LDFLAGS=
ewarn() { :; }
tc-ld-disable-gold
[[ ${LD} == "ld.bfd" || ${LDFLAGS} == *"-fuse-ld=bfd"* ]]
)
tend $?

tbegin "tc-ld-disable-gold (gold selected via flags)"
(
export LD= LDFLAGS="-fuse-ld=gold"
ewarn() { :; }
tc-ld-disable-gold
[[ ${LD} == *"/ld.bfd" || ${LDFLAGS} == "-fuse-ld=gold -fuse-ld=bfd" ]]
)
tend $?


texit
