# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/edje/edje-1.7.10.ebuild,v 1.1 2015/03/17 01:58:29 vapier Exp $

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="graphical layout and animation library"
HOMEPAGE="http://www.enlightenment.org/pages/edje.html"

LICENSE="BSD-2 GPL-2"
IUSE="debug +cache static-libs vim-syntax"

DEPEND="dev-lang/lua
	>=dev-libs/eet-${PV}
	>=dev-libs/eina-${PV}
	>=dev-libs/embryo-${PV}
	>=media-libs/evas-${PV}
	>=dev-libs/ecore-${PV}"
RDEPEND=${DEPEND}

src_configure() {
	E_ECONF=(
		$(use_enable cache edje-program-cache)
		$(use_enable cache edje-calc-cache)
		$(use_enable !debug amalgamation)
		$(use_enable doc)
		$(use_with vim-syntax vim /usr/share/vim)
	)
	enlightenment_src_configure
}

src_install() {
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins data/edc.vim
	fi
	dodoc utils/{gimp-edje-export.py,inkscape2edc}
	enlightenment_src_install
}
