# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools systemd

MY_P="${PN}-v${PV}"

DESCRIPTION="Flow-based network traffic analyser capable of Cisco NetFlow data export"
HOMEPAGE="https://github.com/irino/softflowd"
SRC_URI="https://github.com/irino/${PN}/archive/refs/tags/${MY_P}.tar.gz"
S=${WORKDIR}/${PN}-${MY_P}

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="flow-spray expiry-spray systemd"

DEPEND="
		net-libs/libpcap
		systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {

	local conf=(
		$(use_enable flow-spray flow-spray)
		$(use_enable expiry-spray expiry-spray)
	)

}

src_install() {
	default

	docinto examples
	dodoc collector.pl

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	if use systemd; then
		systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
		systemd_newunit "${FILESDIR}"/${PN}_at.service ${PN}@.service
	fi
}
