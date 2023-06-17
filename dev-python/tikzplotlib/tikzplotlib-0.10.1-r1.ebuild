# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 virtualx

DESCRIPTION="Convert matplotlib figures into TikZ/PGFPlots"
HOMEPAGE="
	https://github.com/texworld/tikzplotlib/
	https://pypi.org/project/tikzplotlib/
"
SRC_URI="https://github.com/texworld/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# https://github.com/texworld/tikzplotlib/issues/567 for mpl-3.6.0 dep
RDEPEND="
	app-text/texlive[extra]
	<dev-python/matplotlib-3.6.0[latex,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/webcolors[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pytest-codeblocks[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.1-matplotlib-3.6.0.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/mock

src_test() {
	local -x MPLBACKEND=Agg
	virtx distutils-r1_src_test
}

python_test() {
	epytest || die "Tests failed with ${EPYTHON}"
}
