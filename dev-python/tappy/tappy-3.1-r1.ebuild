# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 optfeature

MY_PN=tap.py
DESCRIPTION="Test Anything Protocol (TAP) tools"
HOMEPAGE="https://github.com/python-tap/tappy https://pypi.org/project/tap.py/"
SRC_URI="mirror://pypi/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S=${WORKDIR}/${MY_PN}-${PV}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	test? (
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest
distutils_enable_sphinx docs

pkg_postinst() {
	optfeature "YAML blocks associated with test results" \
		"dev-python/more-itertools dev-python/pyyaml"
}
