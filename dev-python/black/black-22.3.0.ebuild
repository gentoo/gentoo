# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

MY_PV="${PV//_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://black.readthedocs.io/en/stable/ https://github.com/psf/black"
SRC_URI="https://github.com/psf/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-3.10.0.0[${PYTHON_USEDEP}]
	' python3_{8..9})
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

export SETUPTOOLS_SCM_PRETEND_VERSION=${MY_PV}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" "dev-python/aiohttp dev-python/aiohttp-cors"
}
