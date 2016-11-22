# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

inherit eutils flag-o-matic toolchain-funcs

MY_P="${P:0:${#P}-2}-${PV:0-1}-mingw32"
DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://www.mingw.org/"
# https://sourceforge.net/projects/mingw/files/MinGW/Base/w32api/
SRC_URI="mirror://sourceforge/mingw/${MY_P}-src.tar.lzma"

LICENSE="BSD"
SLOT="0"
# Collides with mingw-runtime-4.x
#KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

DEPEND="app-arch/xz-utils"
RDEPEND=""

S=${WORKDIR}/${MY_P/-m/.m}-src

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
}

src_configure() {
	just_headers && return 0

	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -frecord-gcc-switches
	tc-export AR
	econf \
		--host=${CTARGET} \
		--prefix=/usr/${CTARGET}/usr \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr/include
		doins -r include/*
	else
		emake -j1 install DESTDIR="${D}"
		env -uRESTRICT CHOST=${CTARGET} prepallstrip

		# Make sure diff cross-compilers don't collide #414075
		mv "${D}"/usr/share/doc/{${PF},${CTARGET}-${PF}} || die
	fi
}
