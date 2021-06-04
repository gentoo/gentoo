# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="ReadTheDocs.org theme for Sphinx"
HOMEPAGE="https://github.com/readthedocs/sphinx_rtd_theme"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE=""

PDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
RDEPEND="<dev-python/docutils-0.17[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${PDEPEND}
		dev-python/readthedocs-sphinx-ext[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_configure() {
	# CI=1 disables rebuilding webpack that requires npm use
	# yes, that surely makes sense
	export CI=1
}
