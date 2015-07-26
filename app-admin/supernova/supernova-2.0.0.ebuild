# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/supernova/supernova-2.0.0.ebuild,v 1.1 2015/07/19 20:24:12 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 distutils-r1 vcs-snapshot

DESCRIPTION="novaclient wrapper for multiple nova environments"
HOMEPAGE="https://github.com/rackerhacker/supernova"
SRC_URI="https://github.com/major/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND="
	${CDEPEND}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/keyring-0.9.2[${PYTHON_USEDEP}]
	dev-python/python-novaclient[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	py.test || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( example_configs/. )

	distutils-r1_python_install_all

	newbashcomp contrib/${PN}-completion.bash ${PN}
}
