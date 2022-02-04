# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit wxwidgets

DESCRIPTION="Photo editor for selective color, saturation, and hue shift adjustments"
HOMEPAGE="https://www.indii.org/software/tintii/"
SRC_URI="https://www.indii.org/files/tint/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="sys-devel/bc"

src_prepare() {
	default
	setup-wxwidgets
}
