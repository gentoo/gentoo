# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Clean customisable Sphinx documentation theme"
HOMEPAGE="https://pypi.org/project/furo/ https://github.com/pradyunsg/furo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~m68k ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

src_prepare() {
	mv src/furo furo || die
	distutils-r1_src_prepare
}
