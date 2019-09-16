# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

inherit autotools flag-o-matic eutils

DESCRIPTION="Free Win64 runtime and import library definitions"
HOMEPAGE="http://mingw-w64.sourceforge.net/"
SRC_URI="mirror://sourceforge/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# USE=libraries needs working stage2 compiler: bug #665512
IUSE="headers-only idl libraries +secure-api tools"
RESTRICT="strip"

S="${WORKDIR}/mingw-w64-v${PV}"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}
just_headers() {
	use headers-only
}
alt_prefix() {
	is_crosscompile && echo /usr/${CTARGET}
}
crt_with() {
	just_headers && echo --without-$1 || echo --with-$1
}
crt_use_enable() {
	just_headers && echo --without-$2 || use_enable "$@"
}
crt_use_with() {
	just_headers && echo --without-$2 || use_with "$@"
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
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

	if ! just_headers; then
		mkdir "${WORKDIR}/headers"
		pushd "${WORKDIR}/headers" > /dev/null
		CHOST=${CTARGET} "${S}/configure" \
			--prefix="${T}/tmproot" \
			--with-headers \
			--without-crt \
			|| die
		popd > /dev/null
		append-cppflags "-I${T}/tmproot/include"
	fi

	# By default configure tries to set --sysroot=${prefix}. We disable
	# this behaviour with --with-sysroot=no to use gcc's sysroot default.
	# That way we can cross-build mingw64-runtime with cross-emerge.
	local prefix="${EPREFIX}"$(alt_prefix)/usr
	CHOST=${CTARGET} econf \
		--with-sysroot=no \
		--prefix="${prefix}" \
		--libdir="${prefix}"/lib \
		--with-headers \
		--enable-sdk \
		$(crt_with crt) \
		$(crt_use_enable idl idl) \
		$(crt_use_with libraries libraries) \
		$(crt_use_with tools tools) \
		$(use_enable secure-api) \
		$(
			$(tc-getCPP ${CTARGET}) ${CPPFLAGS} -dM - < /dev/null | grep -q __MINGW64__ \
				&& echo --disable-lib32 --enable-lib64 \
				|| echo --enable-lib32 --disable-lib64
		)
}

src_compile() {
	if ! just_headers; then
		emake -C "${WORKDIR}/headers" install
	fi
	default
}

src_install() {
	default

	if is_crosscompile ; then
		# gcc is configured to look at specific hard-coded paths for mingw #419601
		dosym usr /usr/${CTARGET}/mingw
		dosym usr /usr/${CTARGET}/${CTARGET}
		dosym usr/include /usr/${CTARGET}/sys-include
	fi

	rm -rf "${ED}/usr/share"
}
