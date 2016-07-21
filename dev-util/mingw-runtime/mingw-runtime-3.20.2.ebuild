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

inherit flag-o-matic autotools versionator eutils

MY_P="mingwrt-$(version_format_string '$1.$2-$3')-mingw32"
DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://www.mingw.org/"
# http://sourceforge.net/projects/mingw/files/MinGW/Base/mingw-rt/
SRC_URI="mirror://sourceforge/mingw/${MY_P}-src.tar.lzma"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

DEPEND="app-arch/xz-utils"

S=${WORKDIR}/${MY_P}

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
	epatch "${FILESDIR}"/${PN}-3.20-LDBL_MIN_EXP.patch #395893
	eautoconf
	sed -i \
		-e '/^install_dlls_host:/s:$: install-dirs:' \
		Makefile.in || die # fix parallel install
}

src_configure() {
	just_headers && return 0

	CHOST=${CTARGET} strip-unsupported-flags
	econf \
		--host=${CTARGET} \
		--with-w32api-srcdir="/usr/${CTARGET}/usr"
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr/include
		doins -r include/* || die
	else
		local insdir
		is_crosscompile \
			&& insdir="${D}/usr/${CTARGET}" \
			|| insdir="${D}"
		emake install DESTDIR="${insdir}" || die
		env -uRESTRICT CHOST=${CTARGET} prepallstrip
		rm -rf "${insdir}"/usr/doc
		docinto ${CTARGET} # Avoid collisions with other cross-compilers.
		dodoc CONTRIBUTORS ChangeLog README TODO readme.txt
	fi
	is_crosscompile && dosym usr /usr/${CTARGET}/mingw
}
