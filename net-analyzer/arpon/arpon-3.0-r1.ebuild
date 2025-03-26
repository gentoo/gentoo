# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="ArpON"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ArpON (Arp handler inspectiON) is a portable Arp handler"
HOMEPAGE="https://arpon.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}-ng.tar.gz"
S="${WORKDIR}/${MY_P}-ng"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0-CFLAGS.patch
	"${FILESDIR}"/${PN}-3.0-gentoo.patch
	"${FILESDIR}"/${PN}-3.0-cmake4.patch
)

DOCS=( AUTHOR CHANGELOG README THANKS )

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/${PN}.initd-3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-3 ${PN}

	rm -r "${ED}"/var/{log,run} || die
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}
