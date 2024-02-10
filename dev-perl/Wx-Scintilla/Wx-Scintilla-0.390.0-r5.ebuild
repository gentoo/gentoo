# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
DIST_AUTHOR=AZAWAWI
DIST_VERSION=0.39
inherit wxwidgets perl-module virtualx

DESCRIPTION="Scintilla source code editing component for wxWidgets"

LICENSE+=" HPND"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

RDEPEND="
	dev-perl/Alien-wxWidgets
	dev-perl/Wx
	x11-libs/wxGTK:${WX_GTK_VER}
"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-XSpp-0.160.200
	>=dev-perl/Module-Build-0.360.0
"
BDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${PN}-0.34-flags.patch
	"${FILESDIR}"/${PN}-0.39-gcc6.patch
)

src_configure() {
	setup-wxwidgets
	myconf=( --verbose )
	perl-module_src_configure
}

src_test() {
	virtx perl-module_src_test
}
