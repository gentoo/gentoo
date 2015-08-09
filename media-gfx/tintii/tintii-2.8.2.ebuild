# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WX_GTK_VER="3.0"

inherit autotools wxwidgets

DESCRIPTION="A photo editor for selective color, saturation, and hue shift adjustments"
HOMEPAGE="http://www.indii.org/software/tintii"
SRC_URI="http://www.indii.org/files/tint/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}
	dev-libs/boost"

src_prepare() {
	sed -i 's/^\(AM_CXXFLAGS = $(DEPS_CXXFLAGS)\).*/\1/' Makefile.am || die
	eautoreconf
}
