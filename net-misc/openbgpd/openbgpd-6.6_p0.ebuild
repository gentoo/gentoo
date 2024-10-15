# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenBGPD is a free implementation of BGPv4"
HOMEPAGE="http://www.openbgpd.org/index.html"
SRC_URI="mirror://openbsd/OpenBGPD/${PN}-${MY_PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	!!net-misc/quagga
	acct-group/_bgpd
	acct-user/_bgpd
"
BDEPEND="
	sys-devel/libtool
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-config.c.patch"
)

src_install() {
	default

	newinitd "${FILESDIR}/${PN}-init.d" bgpd
	newconfd "${FILESDIR}/${PN}-conf.d" bgpd
	systemd_newunit "${FILESDIR}/${PN}.service" bgpd.service
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ]; then
		ewarn ""
		ewarn "OpenBGPD portable (not running on OpenBSD) can’t export its RIB"
		ewarn "to the FIB. It’s only suitable for route-reflectors or"
		ewarn "route-servers."
		ewarn ""
	fi
}
