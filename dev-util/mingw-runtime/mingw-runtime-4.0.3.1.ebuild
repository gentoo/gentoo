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

inherit flag-o-matic toolchain-funcs versionator

MY_P="mingwrt-$(version_format_string '$1.$2.$3-$4')-mingw32"
DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://www.mingw.org/"
# http://sourceforge.net/projects/mingw/files/MinGW/Base/mingw-rt/
SRC_URI="mirror://sourceforge/mingw/${MY_P}-src.tar.lzma"

LICENSE="BSD"
SLOT="0"
# Collides with w32api-4.x
#KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

DEPEND="app-arch/xz-utils"
RDEPEND=""

S=${WORKDIR}/${MY_P}-src

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

src_prepare() {
	sed -i \
		-e '/^install_dlls_host:/s:$: install-dirs:' \
		Makefile.in || die # fix parallel install
}

src_configure() {
	just_headers && return 0

	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -frecord-gcc-switches
	tc-export AR
	econf \
		--host=${CTARGET} \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_compile() {
	emake -j1
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr/include
		doins -r include/*
	else
		local insdir
		is_crosscompile \
			&& insdir="${D}/usr/${CTARGET}" \
			|| insdir="${D}"
		emake -j1 install DESTDIR="${insdir}"
		env -uRESTRICT CHOST=${CTARGET} prepallstrip
		rm -rf "${insdir}"/usr/doc
		docinto ${CTARGET} # Avoid collisions with other cross-compilers.
	fi
	is_crosscompile && dosym usr /usr/${CTARGET}/mingw
}
