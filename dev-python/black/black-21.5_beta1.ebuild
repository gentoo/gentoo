# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 optfeature

MY_PV="${PV//_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://black.readthedocs.io/en/stable/ https://github.com/psf/black"
SRC_URI="https://github.com/psf/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~x64-macos"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	<dev-python/pathspec-1[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typed-ast[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	' python3_7)
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${MY_PV}

python_test() {
	cp "${S}"/src/black_primer/primer.json "${BUILD_DIR}"/lib/black_primer/primer.json || die
	epytest -m "not python2"
}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" dev-python/aiohttp dev-python/aiohttp-cors
}
