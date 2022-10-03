# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.11 blocked by mypy_extensions
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="
	https://black.readthedocs.io/en/stable/
	https://github.com/psf/black/
	https://pypi.org/project/black/
"
SRC_URI="
	https://github.com/psf/black/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-3.10.0.0[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	>=dev-python/setuptools_scm-6.3.1[${PYTHON_USEDEP}]
	test? (
		>=dev-python/aiohttp-3.7.4[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" "dev-python/aiohttp dev-python/aiohttp-cors"
}
