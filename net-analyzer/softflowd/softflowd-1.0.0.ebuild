# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="flow-based network traffic analyser capable of Cisco NetFlow data export"
HOMEPAGE="https://www.mindrot.org/projects/softflowd/"
SRC_URI="https://github.com/irino/${PN}/archive/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"
PATCHES=(
#	"${FILESDIR}"/${PN}-0.9.9-_GNU_SOURCE.patch
)
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	docinto examples
	dodoc collector.pl

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
