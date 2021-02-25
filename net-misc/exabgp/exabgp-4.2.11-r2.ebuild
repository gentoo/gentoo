# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit tmpfiles systemd distutils-r1

DESCRIPTION="The BGP swiss army knife of networking"
HOMEPAGE="https://github.com/Exa-Networks/exabgp"
SRC_URI="https://github.com/Exa-Networks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/exabgp
	acct-user/exabgp
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/exabgp-4.2.7-paths.patch"
	"${FILESDIR}/exabgp-4.2.10-ip-path.patch"
	"${FILESDIR}/exabgp-4.2.11-healthcheck-allow-disable-metric.patch"
	"${FILESDIR}/exabgp-4.2.11-healthcheck-fix-log-crash.patch"
	"${FILESDIR}/exabgp-4.2.11-less-verbose-logging.patch"
)

python_test() {
	./qa/bin/parsing || die "tests fail with ${EPYTHON}"
	nosetests -v ./qa/tests/*_test.py || die "tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}/${PN}.initd-r1" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	newtmpfiles "${FILESDIR}/exabgp.tmpfiles" ${PN}.conf
	systemd_dounit etc/systemd/*

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	keepdir /etc/exabgp

	doman doc/man/*.?
}
