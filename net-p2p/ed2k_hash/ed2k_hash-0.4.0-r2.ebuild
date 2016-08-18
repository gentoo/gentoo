# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic

DESCRIPTION="Tool for generating eDonkey2000 links"
HOMEPAGE="http://ed2k-tools.sourceforge.net/ed2k_hash.shtml"
RESTRICT="mirror"
SRC_URI="mirror://sourceforge/ed2k-tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="" # fltk support is broken, bug #359643

DEPEND=""
RDEPEND=""
#DEPEND="fltk? ( x11-libs/fltk:1 )"

PATCHES=( "${FILESDIR}/ed2k_64bit.patch" )

src_configure() {
#	if use fltk; then
#		append-ldflags "$(fltk-config --ldflags)"
#		export CPPFLAGS="$(fltk-config --cxxflags)"
#	else
		export ac_cv_lib_fltk_main='no'
#	fi

	econf
}

src_install() {
	emake install DESTDIR="${D}" mydocdir=/usr/share/doc/${PF}/html
	einstalldocs
}
