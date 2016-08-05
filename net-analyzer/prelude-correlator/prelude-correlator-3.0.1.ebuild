# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit systemd distutils-r1 python-r1

DESCRIPTION="Real time correlator of events received by Prelude Manager"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-python/setuptools
	${PYTHON_DEPS}"

RDEPEND="dev-python/netaddr[${PYTHON_USEDEP}]
	dev-libs/libprelude[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

src_install() {

	distutils-r1_src_install

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
