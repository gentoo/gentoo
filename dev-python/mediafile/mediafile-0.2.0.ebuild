# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Read and write audio files' tags in Python"
HOMEPAGE="https://github.com/beetbox/mediafile"
SRC_URI="https://github.com/beetbox/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
DEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.33.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_compile_all() {
	if use doc; then
		emake -C docs html
		rm -r docs/_build/html/_sources || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	nosetests -v || die "Tests failed"
	if use doc; then
		sphinx-build -W -q -b html docs __doctest || die "Doc tests failed"
	fi
}
