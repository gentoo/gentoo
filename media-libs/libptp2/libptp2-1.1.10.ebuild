# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Library and client to communicate with cameras via PTP"
HOMEPAGE="https://sourceforge.net/projects/libptp/"
SRC_URI="mirror://sourceforge/libptp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-configure.patch"
)

src_prepare() {
	default
	AT_M4DIR="m4" eautoreconf
}

src_test() {
	env LD_LIBRARY_PATH=./src/.libs/ ./src/ptpcam -l || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	default
}
