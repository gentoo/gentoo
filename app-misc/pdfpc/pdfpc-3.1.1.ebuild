# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Presenter console with multi-monitor support for PDF files"
HOMEPAGE="https://davvil.github.com/pdfpc/"
SRC_URI="mirror://github/davvil/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-text/poppler:=[cairo]
	dev-libs/glib:2
	dev-libs/libgee:0
	gnome-base/librsvg
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

src_configure(){
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}/etc"
	)
	cmake-utils_src_configure
}
