# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils multilib systemd

DESCRIPTION="EC2 initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	dev-python/cheetah[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/oauth[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mocker[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		~dev-python/pep8-1.5.7[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		sys-apps/iproute2
	)
"
RDEPEND="
	${CDEPEND}
	sys-fs/growpart
	virtual/logger
"

PATCHES=( "${FILESDIR}/cloud-init-0.7.6-gentoo.patch" )

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	emake test
}

python_install_all() {
	keepdir /etc/cloud

	distutils-r1_python_install_all

	doinitd "${S}"/sysvinit/gentoo/cloud-config
	doinitd "${S}"/sysvinit/gentoo/cloud-final
	doinitd "${S}"/sysvinit/gentoo/cloud-init
	doinitd "${S}"/sysvinit/gentoo/cloud-init-local
	insinto /etc/cloud/templates
	doins "${FILESDIR}/hosts.gentoo.tmpl"
	insinto /etc/cloud
	doins "${FILESDIR}/cloud.cfg"

	systemd_dounit "${S}"/systemd/cloud-config.service
	systemd_dounit "${S}"/systemd/cloud-config.target
	systemd_dounit "${S}"/systemd/cloud-final.service
	systemd_dounit "${S}"/systemd/cloud-init-local.service
	systemd_dounit "${S}"/systemd/cloud-init.service
}
