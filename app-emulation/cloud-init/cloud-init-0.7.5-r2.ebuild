# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=TRUE

inherit distutils-r1 eutils multilib systemd

DESCRIPTION="Cloud instance initialization"
HOMEPAGE="https://launchpad.net/cloud-init"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	dev-python/cheetah[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/oauth[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${CDEPEND}
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mocker[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pep8[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		sys-apps/iproute2
	)
"
RDEPEND="
	${CDEPEND}
	virtual/logger
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${P}-tests-exclude.patch
	)

	distutils-r1_python_prepare_all

	# Skip SmartOS tests since they don't generally apply and don't skip based
	# on environment.  Documented in bug #511384.
	rm tests/unittests/test_datasource/test_smartos.py
}

python_test() {
	# These tests are not broken but expect to locate an installed exe file
	# other than where a gentoo system installs it;  (/bin/ip sought in /sbin)
	# See cloudinit/sources/DataSourceOpenNebula.py for possible patching
	sed \
		-e 's:test_hostname:_&:' \
		-e 's:test_network_interfaces:_&:' \
		-i tests/unittests/test_datasource/test_opennebula.py

	emake test
}

python_install_all() {
	distutils-r1_python_install_all

	doinitd "${S}"/sysvinit/gentoo/cloud-config
	doinitd "${S}"/sysvinit/gentoo/cloud-final
	doinitd "${S}"/sysvinit/gentoo/cloud-init
	doinitd "${S}"/sysvinit/gentoo/cloud-init-local

	systemd_dounit "${S}"/systemd/cloud-config.service
	systemd_dounit "${S}"/systemd/cloud-config.target
	systemd_dounit "${S}"/systemd/cloud-final.service
	systemd_dounit "${S}"/systemd/cloud-init-local.service
	systemd_dounit "${S}"/systemd/cloud-init.service
}
