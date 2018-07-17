# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 eutils git-r3 multilib systemd

DESCRIPTION="cloud initialisation magic"
HOMEPAGE="https://launchpad.net/cloud-init"
EGIT_REPO_URI="https://git.launchpad.net/cloud-init"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="test"

CDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
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
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/pep8[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/hacking[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	sys-apps/iproute2
	sys-fs/growpart
	virtual/logger
"

PATCHES=( "${FILESDIR}/cloud-init-0.7.8-gentooinit.patch" )

python_prepare_all() {
	sed -i 's/version=get_version(),/version=9999,/g' setup.py || die
	sed -i '/^argparse/d' requirements.txt || die
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	emake test
}

python_install() {
	distutils-r1_python_install "--init-system=sysvinit_openrc"
}

python_install_all() {
	keepdir /etc/cloud

	distutils-r1_python_install_all

	chmod +x "${D}"/etc/init.d/cloud-config
	chmod +x "${D}"/etc/init.d/cloud-final
	chmod +x "${D}"/etc/init.d/cloud-init
	chmod +x "${D}"/etc/init.d/cloud-init-local

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
