# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool multilib toolchain-funcs

PATCH_VER="4"

DESCRIPTION="Compatibility package for binaries linked against a pre gcc 3.4 libstdc++"
HOMEPAGE="https://gcc.gnu.org/libstdc++/"
SRC_URI="
	https://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-${PV}.tar.bz2
	https://dev.gentoo.org/~sam/distfiles/gcc-${PV}-patches-${PATCH_VER}.tar.bz2
"

LICENSE="GPL-2 LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="multilib nls"

RDEPEND="virtual/zlib:="
DEPEND="
	${RDEPEND}
	app-alternatives/yacc"

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

	filter-flags -fdiagnostics-show-option
}

is_arch_allowed() {
	i386_processor_table="i386 i486 i586 pentium pentium-mmx winchip-c6 \
		winchip2 c3 i686 pentiumpro pentium2 pentium3 pentium4 prescott \
		nocona k6 k6-2 k6-3 athlon athlon-tbird x86-64 athlon-4 athlon-xp \
		athlon-mp"

	for proc in ${i386_processor_table} ; do
		[[ "${proc}" == "${1}" ]] && return 0
	done

	mips_processor_table="mips1 mips2 mips3 mips4 mips32 mips64 r3000 r2000 \
		r3900 r6000 r4000 vr4100 vr4111 vr4120 vr4300 r4400 r4600 orion \
		r4650 r8000 vr5000 vr5400 vr5500 4kc 4kp 5kc 20kc sr71000 sb1"

	for proc in ${mips_processor_table} ; do
		[[ "${proc}" == "${1}" ]] && return 0
	done

	rs6000_processor_table="common power power2 power3 power4 powerpc \
		powerpc64 rios rios1 rsc rsc1 rios2 rs64a 401 403 405 505 601 602 \
		603 603e ec603e 604 604e 620 630 740 750 7400 7450 8540 801 821 823 \
		860"

	for proc in ${rs6000_processor_table} ; do
		[[ "${proc}" == "${1}" ]] && return 0
	done

	return 1
}

do_filter_flags() {
	declare setting newflags

	# In general gcc does not like optimization, and add -O1 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	# Compiler crash with -O2, bug #940229
	if is-flagq -O?; then
		newflags+=" -O1"
	fi

	# gcc 3.3 doesn't support -mtune on numerous archs, so xgcc will fail
	setting="`get-flag mtune`"
	[[ ! -z "${setting}" ]] && filter-flags -mtune="${setting}"

	# in gcc 3.3 there is a bug on ppc64 where if -mcpu is used
	# the compiler incorrectly assumes the code you are about to build
	# is 32 bit
	use ppc64 && setting="`get-flag mcpu`"
	[[ ! -z "${setting}" ]] && filter-flags -mcpu="${setting}"

	# only allow the flags that we -know- are supported
	transform_known_flags
	setting="`get-flag march`"
	if [[ ! -z "${setting}" ]] ; then
		is_arch_allowed "${setting}" && newflags+=" -march=${setting}"
	fi
	setting="`get-flag mcpu`"
	if [[ ! -z "${setting}" ]] ; then
		is_arch_allowed "${setting}" && newflags+=" -mcpu=${setting}"
	fi

	# There is lots of brittle old code that violates the aliasing rules. GCC
	# 3.3 supports disabling this optimization.
	newflags+=" -fno-strict-aliasing"

	# Force older c standard due to incompatibilities, bug #944234
	newflags+=" -std=gnu99"

	# xgcc wont understand gcc 3.4 flags... in fact it won't understand most
	# things or have most patches, regardless of what the real GCC understands.
	# A random collection of bugs:
	# #269433 #290202 #442784 #610064 #879775 #919184 #832016
	#
	# There's some extensive discussion at bug #923112, ultimately the only
	# practical approach is to simply reject *all* flags unless we handpicked
	# them to allow them. Check in "${S}"/gcc/doc/gcc.1 before proceeding.
	export CFLAGS="${newflags}"
	export CXXFLAGS="${newflags}"
	unset LDFLAGS
}

S=${WORKDIR}/gcc-${PV}

src_prepare() {
	eapply "${WORKDIR}"/patch/*.patch

	default

	elibtoolize --portage --shallow
	./contrib/gcc_update --touch

	if use multilib && [[ ${SYMLINK_LIB} == "yes" ]] ; then
		# ugh, this shit has to match the way we've hacked gcc else
		# the build falls apart #259215
		sed -i \
			-e 's:\(MULTILIB_OSDIRNAMES = \).*:\1../lib64 ../lib32:' \
			"${S}"/gcc/config/i386/t-linux64 \
			|| die "sed failed!"
	fi

	tc-export AR CC RANLIB NM

	# newer versions of GCC add default werrors that we need to disable for
	# this very old and brittle code. But adding it to CFLAGS doesn't work,
	# since GCC creates xgcc and uses that to compile libstdc++, and the
	# ancient xgcc doesn't understand the flags we need.
	mkdir "${T}/conservative-compiler" || die
	export PATH="${$}/conservative-compiler:${PATH}"

	local realcc=$(type -P "${CC}") || die
	export CC="${T}/conservative-compiler/${CC##*/}"
	cat > "${CC}" <<- __EOF__ || die
		#!/bin/sh
		"${realcc}" -Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types "\$@"
	__EOF__

	chmod +x "${CC}" || die
}

src_configure() {
	mkdir -p "${WORKDIR}"/build
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
}

src_compile() {
	emake \
		-C "${WORKDIR}"/build all-target-libstdc++-v3 \
		AR="$(tc-getAR)" \
		NM="$(tc-getNM)"
}

src_install() {
	emake -j1 \
		-C "${WORKDIR}"/build \
		AR="$(tc-getAR)" \
		NM="$(tc-getNM)" \
		DESTDIR="${D}" \
		install-target-libstdc++-v3

	# scrub everything but the library we care about
	pushd "${D}" >/dev/null
	mv usr/lib* . || die
	rm -rf usr
	rm -f lib*/*.{a,la,so} || die
	dodir /usr
	mv lib* usr/ || die
}
