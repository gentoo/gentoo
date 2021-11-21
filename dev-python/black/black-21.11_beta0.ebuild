# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/click-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	<dev-python/pathspec-1[${PYTHON_USEDEP}]
	<dev-python/tomli-2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		>=dev-python/aiohttp-3.7.4[${PYTHON_USEDEP}]
		dev-python/aiohttp-cors[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${MY_PV}

src_prepare() {
	# remove unnecessary bind that worked around broken 6.1.0/6.2.0 releases
	sed -i -e '/setuptools_scm/s:~=:>=:' \
		-e 's/setuptools_scm\[toml\]>=[0-9.]*/setuptools_scm[toml]/' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	cp "${S}"/src/black_primer/primer.json \
		"${BUILD_DIR}"/lib/black_primer/primer.json || die
	distutils_install_for_testing
	epytest -m "not python2"
}

pkg_postinst() {
	optfeature "blackd - HTTP API for black" dev-python/aiohttp dev-python/aiohttp-cors
}
