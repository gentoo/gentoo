# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_P=typing-${PV}
DESCRIPTION="Type Hint extensions from Python 3.8 backported"
HOMEPAGE="
	https://pypi.org/project/typing-extensions/
	https://github.com/python/typing/"
SRC_URI="
	https://github.com/python/typing/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}/typing_extensions

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

BDEPEND="
	>=dev-python/pyproject2setuppy-21[${PYTHON_USEDEP}]"

python_test() {
	cd "${S}"/src_py3 || die
	"${EPYTHON}" test_typing_extensions.py -v || die "tests failed under ${EPYTHON}"
}
