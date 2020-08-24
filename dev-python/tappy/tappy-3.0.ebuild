# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit distutils-r1

MY_PN=tap.py
DESCRIPTION="Test Anything Protocol (TAP) tools"
HOMEPAGE="https://github.com/python-tap/tappy https://pypi.org/project/tap.py/"
SRC_URI="mirror://pypi/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S=${WORKDIR}/${MY_PN}-${PV}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="yaml"

RDEPEND="
	yaml? (
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"
BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	test? (
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest
