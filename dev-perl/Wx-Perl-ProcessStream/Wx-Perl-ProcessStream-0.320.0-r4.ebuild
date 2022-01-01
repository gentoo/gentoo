# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
DIST_AUTHOR=MDOOTSON
DIST_VERSION=0.32
inherit wxwidgets perl-module virtualx

DESCRIPTION="access IO of external processes via events"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=dev-perl/Wx-0.97.01"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_prepare() {
	setup-wxwidgets
	perl-module_src_prepare
}

src_test() {
	virtx perl-module_src_test
}
