# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit linux-info

DESCRIPTION="The Linux Precision Time Protocol (PTP) implementation"
HOMEPAGE="http://linuxptp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/v${PV}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

CONFIG_CHECK="~PPS ~NETWORK_PHY_TIMESTAMPING ~PTP_1588_CLOCK"

src_compile() {
	export EXTRA_CFLAGS=${CFLAGS}
	emake prefix=/usr mandir=/usr/share/man
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		libdir="${D}"/usr/$(get_libdir) \
		install

	dodoc README.org
}
