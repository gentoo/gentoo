# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

SRC_URI="https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/${P}.tar.gz"

DESCRIPTION="An AtomicLong type using CFFI."
HOMEPAGE="https://github.com/dreid/atomiclong"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/python-cffi[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	pytest -vv || die
}
