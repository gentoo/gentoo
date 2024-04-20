# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A one-wire weather station for Dallas Semiconductor"
HOMEPAGE="http://oww.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls usb"

RDEPEND="
	net-misc/curl
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.86.4-build.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-interactive \
		$(use_enable nls) \
		$(use_enable gtk gui) \
		$(use_with usb)
}
