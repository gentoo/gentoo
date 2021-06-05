# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="python-quantities"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Support for physical quantities with units, based on numpy"
HOMEPAGE="https://github.com/python-quantities/python-quantities"
SRC_URI="https://github.com/python-quantities/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/numpy[$PYTHON_USEDEP]
"

distutils_enable_tests unittest

python_prepare_all() {
	# Unexpected success
	sed -i -e 's:test_fix:_&:' \
		quantities/tests/test_umath.py || die

	distutils-r1_python_prepare_all
}
