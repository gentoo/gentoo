# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Simple Python interface for Graphviz"
HOMEPAGE="https://graphviz.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
KEYWORDS="amd64 ~riscv x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND="
	media-gfx/graphviz
"
BDEPEND="
	app-arch/unzip
	test? (
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.8[${PYTHON_USEDEP}]
		media-gfx/graphviz[gts,pdf]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--cov --cov-report=term --cov-report=html::' \
		-i setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" run-tests.py -vv -ra -l -Wdefault -p no:xdoctest ||
		die "Tests failed with ${EPYTHON}"
}
