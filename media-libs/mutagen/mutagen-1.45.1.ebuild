# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Audio metadata tag reader and writer implemented in pure Python"
HOMEPAGE="https://github.com/quodlibet/mutagen https://pypi.org/project/mutagen/"
SRC_URI="https://github.com/quodlibet/mutagen/releases/download/release-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

# TODO: Missing support for >=dev-python/eyeD3-0.7 API
# test? ( >=dev-python/eyeD3-0.7 )
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

RESTRICT="!test? ( test )"

DOCS=( NEWS README.rst )

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

python_test() {
	esetup.py test --no-quality
}
