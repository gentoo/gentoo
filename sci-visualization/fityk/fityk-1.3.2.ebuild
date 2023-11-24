# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )
WX_GTK_VER=3.2-gtk3

inherit flag-o-matic lua-single wxwidgets xdg

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="https://fityk.nieto.pl/"
SRC_URI="https://github.com/wojdyr/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="gnuplot nlopt readline wxwidgets"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	dev-libs/boost:=
	>=sci-libs/xylib-1
	nlopt? ( sci-libs/nlopt )
	readline? ( sys-libs/readline:0= )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )
"
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )
"
BDEPEND="dev-lang/swig"

src_configure() {
	# codebase relies on dynamic exception specifications
	# for SWIG, no point in trying to fix at this point.
	# https://github.com/wojdyr/fityk/pull/38
	append-cxxflags -std=c++14

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
	find "${ED}" -name '*.la' -delete || die

	mv "${ED}"/usr/share/appdata "${ED}"/usr/share/metainfo || die
}
