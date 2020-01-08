# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="reaver-wps-fork-t6x"

DESCRIPTION="Brute force attack against Wifi Protected Setup"
HOMEPAGE="https://github.com/t6x/${MY_PN}"
SRC_URI="https://github.com/t6x/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}/src"

PATCHES=(
	"${FILESDIR}"/${P}-confdir.patch
)

src_install() {
	# Upstream's Makefile does the same but in non-standard way.
	dobin wash reaver

	doman ../docs/reaver.1
	dodoc ../docs/README ../docs/README.REAVER ../docs/README.WASH

	keepdir /var/lib/reaver
}
