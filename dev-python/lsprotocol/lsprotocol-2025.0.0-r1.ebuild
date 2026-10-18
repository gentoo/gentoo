# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..15})

inherit edo distutils-r1

DESCRIPTION="Language Server Protocol types code generator packages"
HOMEPAGE="
	https://github.com/microsoft/lsprotocol
	https://pypi.org/project/lsprotocol/
"
# no tests in sdist
SRC_URI="
	https://github.com/microsoft/lsprotocol/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${S}/packages/python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/cattrs[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pyhamcrest[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/lsprotocol-2025.0.0-fix-against-cattrs-25.0.0.patch
)

src_prepare() {
	pushd "${WORKDIR}/${P}" >/dev/null || die
	default
	popd >/dev/null || die
}

python_test() {
	epytest ../../tests/python
}
