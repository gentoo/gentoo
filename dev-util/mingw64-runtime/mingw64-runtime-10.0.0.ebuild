# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} && ${CATEGORY} == cross-* ]]; then
	export CTARGET=${CATEGORY#cross-}
fi

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Free Win64 runtime and import library definitions"
HOMEPAGE="https://www.mingw-w64.org/"
SRC_URI="mirror://sourceforge/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${PV}.tar.bz2"
S="${WORKDIR}/mingw-w64-v${PV}"

LICENSE="ZPL BSD BSD-2 ISC LGPL-2+ LGPL-2.1+ MIT public-domain tools? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# USE=libraries needs working stage2 compiler: bug #665512
IUSE="headers-only idl libraries tools"
RESTRICT="strip"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.0-fortify-only-ssp.patch
)

mingw-is_cross() {
	[[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} && ${CHOST} == ${CTARGET} ]]; then
		die "Invalid configuration"
	fi
}

src_configure() {
	CHOST=${CTARGET} strip-unsupported-flags

	# Normally mingw-64 does not use dynamic linker.
	# But at configure time it uses $LDFLAGS.
	# When default -Wl,--hash-style=gnu is passed
	# __CTORS_LIST__ / __DTORS_LIST__ is mis-detected
	# for target ld and binaries crash at shutdown.
	filter-ldflags '-Wl,--hash-style=*'

	if use !headers-only; then
		mkdir "${WORKDIR}"/headers || die
		pushd "${WORKDIR}"/headers >/dev/null || die

		local econfargs=(
			--prefix="${T}"/tmproot
			--with-headers
			--without-crt
		)

		CHOST=${CTARGET} ECONF_SOURCE=${S} econf "${econfargs[@]}"

		popd >/dev/null || die

		append-cppflags "-I${T}/tmproot/include"
	fi

	crt-use_enable() {
		use headers-only && echo --without-${2:-${1}} || use_enable "${@}"
	}
	crt-use_with() {
		use headers-only && echo --without-${2:-${1}} || use_with "${@}"
	}

	local prefix="${EPREFIX}"$(mingw-is_cross && echo /usr/${CTARGET})/usr
	local econfargs=(
		--prefix="${prefix}"
		--libdir="${prefix}"/lib
		--enable-sdk
		--with-headers

		# By default configure tries to set --sysroot=${prefix}. We disable
		# this behaviour with --with-sysroot=no to use gcc's sysroot default.
		# That way we can cross-build mingw64-runtime with cross-emerge.
		--with-sysroot=no

		$(use_with !headers-only crt)
		$(crt-use_enable idl)
		$(crt-use_with libraries)
		$(crt-use_with tools)
		$(
			if use !headers-only; then
				# not checking cpp errors due to bug #840662
				$(tc-getCPP ${CTARGET}) ${CPPFLAGS} -dM - </dev/null | grep -q __MINGW64__ \
					&& echo --disable-lib32 --enable-lib64 \
					|| echo --enable-lib32 --disable-lib64
			fi
		)
	)

	CHOST=${CTARGET} econf "${econfargs[@]}"
}

src_compile() {
	use headers-only || emake -C "${WORKDIR}"/headers install

	default
}

src_install() {
	default

	if mingw-is_cross; then
		# gcc is configured to look at specific hard-coded paths for mingw #419601
		dosym usr /usr/${CTARGET}/mingw
		dosym usr /usr/${CTARGET}/${CTARGET}
		dosym usr/include /usr/${CTARGET}/sys-include
	fi

	rm -r "${ED}"/usr/share || die
}
