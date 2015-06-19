# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mingw64-runtime/mingw64-runtime-3.0.0.ebuild,v 1.3 2015/02/27 08:11:21 vapier Exp $

EAPI=5

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

inherit flag-o-matic eutils

DESCRIPTION="Free Win64 runtime and import library definitions"
HOMEPAGE="http://mingw-w64.sourceforge.net/"
SRC_URI="mirror://sourceforge/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crosscompile_opts_headers-only idl"
RESTRICT="strip"

S="${WORKDIR}/mingw-w64-v${PV}"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}
just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_configure() {
	local extra_conf=()

	if just_headers; then
		extra_conf+=( --without-crt )
	else
		extra_conf+=( --with-crt )
	fi

	case ${CTARGET} in
	x86_64*) extra_conf+=( --disable-lib32 --enable-lib64 ) ;;
	i?86*) extra_conf+=( --enable-lib32 --disable-lib64 ) ;;
	*) die "Unsupported ${CTARGET}" ;;
	esac

	CHOST=${CTARGET} strip-unsupported-flags
	CHOST=${CTARGET} econf \
		--prefix=/usr/${CTARGET} \
		--includedir=/usr/${CTARGET}/usr/include \
		--with-headers \
		--enable-sdk \
		$(use_enable idl) \
		"${extra_conf[@]}"
}

src_install() {
	default

	if is_crosscompile ; then
		# gcc is configured to look at specific hard-coded paths for mingw #419601
		dosym usr /usr/${CTARGET}/mingw
		dosym usr /usr/${CTARGET}/${CTARGET}
		dosym usr/include /usr/${CTARGET}/sys-include
	fi

	env -uRESTRICT CHOST=${CTARGET} prepallstrip
	rm -rf "${ED}/usr/share"
}
