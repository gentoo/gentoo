# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 systemd

DESCRIPTION="This is an OSP server implementation to allow GVM to remotely control OpenVAS"
HOMEPAGE="https://github.com/greenbone/ospd-openvas"
SRC_URI="https://github.com/greenbone/ospd-openvas/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	acct-user/gvm
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/redis-py[${PYTHON_USEDEP}]
	net-analyzer/ospd[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=net-analyzer/openvas-scanner-7.0.0"
BDEPEND=""

distutils_enable_tests unittest

python_install() {
	distutils-r1_python_install

	insinto /etc/openvas
	doins "${FILESDIR}"/redis.conf.example
	doins "${FILESDIR}"/ospd.conf

	fowners -R gvm:gvm /etc/openvas

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	systemd_dounit "${FILESDIR}/${PN}.service"
}
