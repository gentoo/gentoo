# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="A program for announcing VLANs using GVRP"
HOMEPAGE="http://zagrodzki.net/~sebek/gvrpcd/"
SRC_URI="http://zagrodzki.net/~sebek/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libnet:1.1"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~VLAN_8021Q ~VLAN_8021Q_GVRP"

PATCHES=(
	"${FILESDIR}/${PN}-respect-ldflags.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin ${PN}
	dodoc README
	newinitd "${FILESDIR}/init.gvrpcd" ${PN}
	newconfd "${FILESDIR}/conf.gvrpcd" ${PN}
}
