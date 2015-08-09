# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
SRC_URI="mirror://sourceforge/mingw-w64/mingw-w64-v${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

S=${WORKDIR}/mingw-w64-v${PV}/mingw-w64-crt

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

src_unpack() {
	unpack ${A}
	find "${WORKDIR}" -type f -exec touch -r . {} +
}

src_compile() {
	# install the local headers as the crt step wants latest
	pushd ../mingw-w64-headers >/dev/null
	CHOST=${CTARGET} econf --enable-sdk || die
	emake install DESTDIR="${WORKDIR}/sysroot" || die
	popd >/dev/null

	just_headers && return 0

	CHOST=${CTARGET} strip-unsupported-flags
	append-cppflags -isystem "${WORKDIR}/sysroot/usr/${CTARGET}/include"
	CHOST=${CTARGET} econf || die
	emake || die
}

src_install() {
	insinto /usr/${CTARGET}/usr/include
	doins -r "${WORKDIR}"/sysroot/usr/${CTARGET}/include/* || die
	if is_crosscompile ; then
		# gcc is configured to look at specific hard-coded paths for mingw #419601
		dosym usr /usr/${CTARGET}/mingw
		dosym usr /usr/${CTARGET}/${CTARGET}
		dosym usr/include /usr/${CTARGET}/sys-include
	fi
	just_headers && return 0

	emake install DESTDIR="${D}" || die
	env -uRESTRICT CHOST=${CTARGET} prepallstrip
	rm -rf "${D}"/usr/doc
}
