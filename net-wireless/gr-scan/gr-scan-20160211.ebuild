# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Frequency scanner for GNU Radio"
HOMEPAGE="http://git.zx2c4.com/gr-scan/about"
#SRC_URI="http://git.zx2c4.com/${PN}/snapshot/${P}.tar.xz"
COMMIT="25030f6063e796e5cb048ffc1ec7e1914192146b"
SRC_URI="https://git.zx2c4.com/${PN}/snapshot/${PN}-${COMMIT}.tar.xz -> ${P}.tar.xz"
LICENSE="GPL-3"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-wireless/gnuradio:=
	net-wireless/gr-osmosdr:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i 's#install -s#install#' Makefile
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
