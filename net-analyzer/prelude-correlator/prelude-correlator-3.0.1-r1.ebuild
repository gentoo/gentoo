# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit systemd distutils-r1

DESCRIPTION="Real time correlator of events received by Prelude Manager"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools"

RDEPEND="dev-python/netaddr[${PYTHON_USEDEP}]
	dev-libs/libprelude[python,${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
