# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="ReadTheDocs.org theme for Sphinx"
HOMEPAGE="
	https://github.com/readthedocs/sphinx_rtd_theme/
	https://pypi.org/project/sphinx-rtd-theme/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-jquery-4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/readthedocs-sphinx-ext[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# remove upper bounds
	sed -i -e 's:,\?<[0-9.]*::' setup.cfg || die
	distutils-r1_src_prepare

	# CI=1 disables rebuilding webpack that requires npm use
	# yes, that surely makes sense
	export CI=1
}
