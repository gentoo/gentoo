# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyrax/pyrax-1.9.3.ebuild,v 1.1 2014/11/24 01:23:53 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python language bindings for OpenStack Clouds"
HOMEPAGE="https://github.com/rackspace/pyrax"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

CDEPEND="
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.13.0[${PYTHON_USEDEP}]
	dev-python/rackspace-novaclient[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${CDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/rax-scheduled-images-python-novaclient-ext[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_test() {
	#ebegin 'patching tests/unit/test_utils.py'
	#sed \
	#	-e '92,100d' \
	#	-i tests/unit/test_utils.py
	#STATUS=$?
	#eend ${STATUS}
	#[[ ${STATUS} -gt 0 ]] && die

	nosetests tests/unit || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( samples/. )

	distutils-r1_python_install_all
}
