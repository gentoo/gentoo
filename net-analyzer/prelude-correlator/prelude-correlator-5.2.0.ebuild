# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 systemd tmpfiles

DESCRIPTION="Real time correlator of events received by Prelude Manager"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/5.2.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/libprelude-5.2.0[python,${PYTHON_USEDEP}]
	<dev-libs/libprelude-6[python,${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-5.2.0-fix_siteconfig.patch"
)

src_install() {
	distutils-r1_src_install

	keepdir /var/${PN}
	keepdir /var/spool/prelude/prelude-correlator

	systemd_dounit "${FILESDIR}/${PN}.service"
	newtmpfiles "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
