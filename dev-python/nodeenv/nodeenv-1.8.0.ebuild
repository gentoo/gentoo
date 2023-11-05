# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Node.js virtual environment builder"
HOMEPAGE="
	https://github.com/ekalinin/nodeenv/
	https://pypi.org/project/nodeenv/
"
SRC_URI="
	https://github.com/ekalinin/nodeenv/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~ppc ~ppc64 x86"

# See https://github.com/ekalinin/nodeenv/issues/333 for which.
RDEPEND="
	sys-apps/which
"
# Coverage is genuinely required for tests.
# tests/nodeenv_test.py::test_smoke
# tests/nodeenv_test.py::test_smoke_n_system_special_chars
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
