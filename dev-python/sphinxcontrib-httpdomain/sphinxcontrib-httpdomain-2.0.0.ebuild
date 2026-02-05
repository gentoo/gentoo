# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Sphinx domain for documenting HTTP APIs"
HOMEPAGE="
	https://pypi.org/project/sphinxcontrib-httpdomain/
	https://github.com/sphinx-contrib/httpdomain/
"
SRC_URI="
	https://github.com/sphinx-contrib/httpdomain/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/httpdomain-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/sphinx-6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/bottle-0.13.4[${PYTHON_USEDEP}]
		>=dev-python/flask-3.1.2[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.5.4[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	cd "${T}" || die
	epytest "${S}"/test
}
