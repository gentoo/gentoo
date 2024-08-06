# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg

DESCRIPTION="Conway's Life simulator for Unix"
HOMEPAGE="https://homeforaday.org/gtklife/"
SRC_URI="https://homeforaday.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-gtk2
		--with-docdir=/usr/share/doc/${PF}/html
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r graphics patterns

	newicon -s 48 icon_48x48.png ${PN}.png
	make_desktop_entry ${PN} GtkLife

	dodoc -r doc/*
	dodoc AUTHORS README NEWS
}
