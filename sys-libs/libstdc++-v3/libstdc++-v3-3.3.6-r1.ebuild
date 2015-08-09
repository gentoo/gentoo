# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic libtool multilib

transform_known_flags() {
	declare setting

	# and on x86, we just need to filter the 3.4 specific amd64 -marchs
	replace-cpu-flags k8 athlon64 opteron x86-64

	# gcc 3.3 doesn't support -march=pentium-m
	replace-cpu-flags pentium-m pentium3m pentium3

	#GCC 3.3 does not understand G3, G4, G5 on ppc
	replace-cpu-flags G3 750
	replace-cpu-flags G4 7400
	replace-cpu-flags G5 7400
}

is_arch_allowed() {
	i386_processor_table="i386 i486 i586 pentium pentium-mmx winchip-c6 \
		winchip2 c3 i686 pentiumpro pentium2 pentium3 pentium4 prescott \
		nocona k6 k6-2 k6-3 athlon athlon-tbird x86-64 athlon-4 athlon-xp \
		athlon-mp"

	for proc in ${i386_processor_table} ; do
		[ "${proc}" == "${1}" ] && return 0
	done

	mips_processor_table="mips1 mips2 mips3 mips4 mips32 mips64 r3000 r2000 \
		r3900 r6000 r4000 vr4100 vr4111 vr4120 vr4300 r4400 r4600 orion \
		r4650 r8000 vr5000 vr5400 vr5500 4kc 4kp 5kc 20kc sr71000 sb1"

	for proc in ${mips_processor_table} ; do
		[ "${proc}" == "${1}" ] && return 0
	done

	rs6000_processor_table="common power power2 power3 power4 powerpc \
		powerpc64 rios rios1 rsc rsc1 rios2 rs64a 401 403 405 505 601 602 \
		603 603e ec603e 604 604e 620 630 740 750 7400 7450 8540 801 821 823 \
		860"

	for proc in ${rs6000_processor_table} ; do
		[ "${proc}" == "${1}" ] && return 0
	done

	return 1
}

do_filter_flags() {
	declare setting

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	replace-flags -O? -O2

	# gcc 3.3 doesn't support -mtune on numerous archs, so xgcc will fail
	setting="`get-flag mtune`"
	[ ! -z "${setting}" ] && filter-flags -mtune="${setting}"

	# in gcc 3.3 there is a bug on ppc64 where if -mcpu is used
	# the compiler incorrectly assumes the code you are about to build
	# is 32 bit
	use ppc64 && setting="`get-flag mcpu`"
	[ ! -z "${setting}" ] && filter-flags -mcpu="${setting}"

	# only allow the flags that we -know- are supported
	transform_known_flags
	setting="`get-flag march`"
	if [ ! -z "${setting}" ] ; then
		is_arch_allowed "${setting}" || filter-flags -march="${setting}"
	fi
	setting="`get-flag mcpu`"
	if [ ! -z "${setting}" ] ; then
		is_arch_allowed "${setting}" || filter-flags -mcpu="${setting}"
	fi

	# xgcc wont understand gcc 3.4 flags...
	filter-flags -fno-unit-at-a-time
	filter-flags -funit-at-a-time
	filter-flags -fweb
	filter-flags -fno-web
	filter-flags -mno-tls-direct-seg-refs

	# xgcc isnt patched with propolice
	filter-flags -fstack-protector-all
	filter-flags -fno-stack-protector-all
	filter-flags -fstack-protector
	filter-flags -fno-stack-protector

	# xgcc isnt patched with the gcc symbol visibility patch
	filter-flags -fvisibility-inlines-hidden
	filter-flags -fvisibility=hidden

	# Bug #269433 & #290202
	filter-flags -fno-strict-overflow
	filter-flags -fstrict-overflow

	# Bug #442784
	filter-flags '-W*'

	filter-flags -frecord-gcc-switches

	# ...sure, why not?
	strip-unsupported-flags

	strip-flags
}

PATCH_VER="1.9"

DESCRIPTION="Compatibility package for running binaries linked against a pre gcc 3.4 libstdc++"
HOMEPAGE="http://gcc.gnu.org/libstdc++/"
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-${PV}.tar.bz2
	mirror://gentoo/gcc-${PV}-patches-${PATCH_VER}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~mips ppc -ppc64 sparc x86 ~x86-fbsd"
IUSE="multilib nls"

DEPEND="sys-devel/bison"
RDEPEND=""

S=${WORKDIR}/gcc-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	elibtoolize --portage --shallow
	./contrib/gcc_update --touch
	mkdir -p "${WORKDIR}"/build

	if use multilib && [[ ${SYMLINK_LIB} == "yes" ]] ; then
		# ugh, this shit has to match the way we've hacked gcc else
		# the build falls apart #259215
		sed -i \
			-e 's:\(MULTILIB_OSDIRNAMES = \).*:\1../lib64 ../lib32:' \
			"${S}"/gcc/config/i386/t-linux64 \
			|| die "sed failed!"
	fi
}

src_compile() {
	cd "${WORKDIR}"/build
	do_filter_flags
	ECONF_SOURCE=${S} \
	econf \
		--enable-shared \
		--with-system-zlib \
		--enable-languages=c++ \
		--enable-threads=posix \
		--enable-long-long \
		--disable-checking \
		--enable-cstdio=stdio \
		--enable-__cxa_atexit \
		$(use_enable multilib) \
		$(use_enable nls) \
		$(use_with !nls included-gettext)

	touch "${S}"/gcc/c-gperf.h

	emake all-target-libstdc++-v3 || die
}

src_install() {
	emake -j1 \
		-C "${WORKDIR}"/build \
		DESTDIR="${D}" \
		install-target-libstdc++-v3 || die

	# scrub everything but the library we care about
	pushd "${D}" >/dev/null
	mv usr/lib* . || die
	rm -rf usr
	rm -f lib*/*.{a,la,so} || die
	dodir /usr
	mv lib* usr/ || die
}
