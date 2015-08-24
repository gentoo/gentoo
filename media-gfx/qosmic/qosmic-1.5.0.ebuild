# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit qt4-r2

DESCRIPTION="A cosmic recursive flame fractal editor"
HOMEPAGE="https://code.google.com/p/qosmic/"
SRC_URI="https://qosmic.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1.4
	>=media-gfx/flam3-3.0.1
	|| ( ( >=dev-qt/qtgui-4.8.5:4 dev-qt/designer:4 ) <dev-qt/qtgui-4.8.5:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="changes.txt README"
