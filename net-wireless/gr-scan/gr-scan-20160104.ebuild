# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Frequency scanner for GNU Radio"
HOMEPAGE="http://git.zx2c4.com/gr-scan/about"
SRC_URI="http://git.zx2c4.com/${PN}/snapshot/${P}.tar.xz"
LICENSE="GPL-3"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-wireless/gnuradio
	net-wireless/gr-osmosdr
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
