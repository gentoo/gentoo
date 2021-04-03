# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="unittest subTest() support and subtests fixture"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-subtests/
	https://pypi.org/project/pytest-subtests/"
SRC_URI="
	https://github.com/pytest-dev/pytest-subtests/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-python/pytest-5.3.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions
	' python3_7 pypy3)
"
# pytest-xdist is used to test compatibility
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)"

distutils_enable_tests --install pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
