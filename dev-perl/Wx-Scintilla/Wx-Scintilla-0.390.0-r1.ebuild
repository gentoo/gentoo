# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"
#VIRTUALX_REQUIRED=test
#inherit virtualx
MODULE_AUTHOR=AZAWAWI
MODULE_VERSION=0.39
inherit wxwidgets perl-module

DESCRIPTION="Scintilla source code editing component for wxWidgets"
SRC_URI+=" https://dev.gentoo.org/~tove/distfiles/dev-perl/${PN}-0.34-patches.tar.gz"

LICENSE+=" HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Alien-wxWidgets
	dev-perl/wxperl
	x11-libs/wxGTK:${WX_GTK_VER}
"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-XSpp-0.160.200
	>=dev-perl/Module-Build-0.360.0
"

PATCHES=(
	"${WORKDIR}"/${PN}-patches/0.34-flags.patch
)

src_configure() {
	myconf=( --verbose )
	perl-module_src_configure
}

#SRC_TEST=do
#src_test() {
#	VIRTUALX_COMMAND="./Build" virtualmake test || die
#}
