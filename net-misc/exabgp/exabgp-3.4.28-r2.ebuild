# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit tmpfiles systemd distutils-r1

DESCRIPTION="The BGP swiss army knife of networking"
HOMEPAGE="https://github.com/Exa-Networks/exabgp"
SRC_URI="https://github.com/Exa-Networks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/exabgp
	acct-user/exabgp
	dev-python/ipaddr[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	newtmpfiles "${FILESDIR}/exabgp.tmpfiles" ${PN}.conf
	systemd_dounit etc/systemd/*

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	keepdir /etc/exabgp
}
