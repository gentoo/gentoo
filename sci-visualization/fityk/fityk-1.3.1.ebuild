# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER=3.0

inherit fdo-mime wxwidgets

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="http://fityk.nieto.pl/"
SRC_URI="https://github.com/wojdyr/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="gnuplot nlopt readline static-libs wxwidgets"

CDEPEND="
	>=dev-lang/lua-5.1:0
	dev-libs/boost:=
	>=sci-libs/xylib-1
	nlopt? ( sci-libs/nlopt )
	readline? ( sys-libs/readline:0= )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )"
DEPEND="${CDEPEND}
	dev-lang/swig"
RDEPEND="${CDEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

pkg_setup() {
	use wxwidgets && setup-wxwidgets
}

src_configure() {
	common_confargs=(
		--with-wx-config=wx-config-${WX_GTK_VER}
	)

	econf \
		"${common_confargs[@]}" \
		--disable-python \
		$(use_enable nlopt) \
		$(use_enable wxwidgets GUI) \
		$(use_with readline) \
		$(use_enable static-libs static)
}

src_install() {
	default

	# No .pc file / libfityk.a has dependencies -> need .la file
	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
