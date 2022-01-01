# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER=3.0

inherit wxwidgets xdg

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="https://fityk.nieto.pl/"
SRC_URI="https://github.com/wojdyr/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="gnuplot nlopt readline wxwidgets"

DEPEND="
	>=dev-lang/lua-5.1:0
	dev-libs/boost:=
	>=sci-libs/xylib-1
	nlopt? ( sci-libs/nlopt )
	readline? ( sys-libs/readline:0= )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )"
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )"
BDEPEND="dev-lang/swig"

src_configure() {
	use wxwidgets && setup-wxwidgets

	econf \
		--disable-python \
		--disable-static \
		$(use_enable nlopt) \
		$(use_enable wxwidgets GUI) \
		$(use_with readline) \
		--with-wx-config="${WX_CONFIG}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
