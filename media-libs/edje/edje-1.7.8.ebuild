# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit autotools enlightenment

DESCRIPTION="graphical layout and animation library"
HOMEPAGE="http://www.enlightenment.org/pages/edje.html"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2 GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug +cache static-libs vim-syntax"

DEPEND="dev-lang/lua
	>=dev-libs/eet-1.7.8
	>=dev-libs/eina-1.7.8
	>=dev-libs/embryo-1.7.4
	>=media-libs/evas-1.7.8
	>=dev-libs/ecore-1.7.8"
RDEPEND=${DEPEND}

src_prepare() {
	sed -i "s:1.7.8:1.7.4:g" configure.ac
	eautoreconf
}

src_configure() {
	MY_ECONF+="
		$(use_enable cache edje-program-cache)
		$(use_enable cache edje-calc-cache)
		$(use_enable !debug amalgamation)
		$(use_enable doc)
		$(use_with vim-syntax vim /usr/share/vim)
	"
	enlightenment_src_configure
}

src_install() {
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins data/edc.vim || die
	fi
	dodoc utils/{gimp-edje-export.py,inkscape2edc} || die
	enlightenment_src_install
}
