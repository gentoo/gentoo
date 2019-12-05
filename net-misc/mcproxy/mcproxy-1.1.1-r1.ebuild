# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info qmake-utils systemd

DESCRIPTION="A multicast proxy for IGMP/MLD"
HOMEPAGE="https://mcproxy.realmv6.org/ https://github.com/mcproxy/mcproxy"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

DEPEND="
	dev-qt/qtcore:5
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${P}/${PN}"

PATCHES=( "${FILESDIR}/fix_checksum_calculation.patch" )

CONFIG_CHECK="~IP_MULTICAST ~IP_MROUTE"

src_prepare() {
	# Change install path from '/usr/local/bin' to '/usr/bin'
	sed -e 's/local//' -i mcproxy.pro || die

	default
}

src_configure() {
	eqmake5
}

src_compile() {
	default

	use doc && emake doc
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	insinto /etc
	doins mcproxy.conf

	newinitd "${FILESDIR}"/mcproxy.initd mcproxy
	systemd_dounit "${FILESDIR}"/mcproxy.service

	newconfd "${FILESDIR}"/mcproxy.confd mcproxy

	use doc && dodoc -r ../docs/.
}
