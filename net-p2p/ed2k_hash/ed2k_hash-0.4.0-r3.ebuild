# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#inherit flag-o-matic

DESCRIPTION="Tool for generating eDonkey2000 links"
HOMEPAGE="http://ed2k-tools.sourceforge.net/ed2k_hash.shtml"
SRC_URI="mirror://sourceforge/ed2k-tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="" # fltk support is broken, bug #359643

RESTRICT="mirror"

#DEPEND="fltk? ( x11-libs/fltk:1 )"

PATCHES=(
	"${FILESDIR}/ed2k_64bit.patch"
	"${FILESDIR}/${PN}-0.4.0-missing-includes.patch"
)

src_configure() {
	#if use fltk; then
	#	append-ldflags "$(fltk-config --ldflags)"
	#	export CPPFLAGS="$(fltk-config --cxxflags)"
	#else
		export ac_cv_lib_fltk_main='no'
	#fi

	econf
}

src_install() {
	emake install DESTDIR="${D}" mydocdir=/usr/share/doc/${PF}/html
	einstalldocs
}
