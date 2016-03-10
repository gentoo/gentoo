# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
MODULE_AUTHOR=MDOOTSON
MODULE_VERSION=0.32
inherit wxwidgets perl-module

DESCRIPTION="access IO of external processes via events"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=dev-perl/Wx-0.97.01"
DEPEND="${RDEPEND}"

#SRC_TEST=do

src_prepare() {
	need-wxwidgets unicode
	perl-module_src_prepare
}
