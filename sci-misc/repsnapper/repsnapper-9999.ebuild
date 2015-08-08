# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools git-2

DESCRIPTION="Host software for controlling the RepRap open source 3D printer"
HOMEPAGE="https://github.com/timschmidt/repsnapper"
EGIT_REPO_URI="git://github.com/timschmidt/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-cpp/gtkglextmm-1.2
	>=dev-cpp/gtkmm-2.4
	dev-cpp/libxmlpp
	dev-libs/libzip
	virtual/opengl
"
RDEPEND=${DEPEND}

src_prepare() {
	eautoreconf
}
