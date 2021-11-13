# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

COMMIT=0c26c1c4e288e0d41d2c3890d5b3befa7579455c

DESCRIPTION="Data parsing and validation using Python type hints"
HOMEPAGE="https://github.com/samuelcolvin/pydantic"
# No tests on PyPI: https://github.com/samuelcolvin/pydantic/pull/1976
SRC_URI="
	https://github.com/samuelcolvin/pydantic/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~sparc x86"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/python-email-validator[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-update-py3.10rc1.patch"
)

distutils_enable_tests --install pytest

src_prepare() {
	# seriously?
	sed -i -e '/CFLAGS/d' setup.py || die
	distutils-r1_src_prepare
}
