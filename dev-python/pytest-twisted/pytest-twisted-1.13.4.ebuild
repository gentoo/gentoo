# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Test twisted code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-twisted"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest

python_test() {
	# tests fail on Python 3.10 due to deprecation of threading.currentThread()
	# https://github.com/pytest-dev/pytest-twisted/issues/146
	[[ ${EPYTHON} == python3.10 ]] || distutils-r1_python_test
}

