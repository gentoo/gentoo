# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A self-contained cryptographic library for Python"
HOMEPAGE="https://www.pycryptodome.org/
	https://github.com/Legrandin/pycryptodome/
	https://pypi.org/project/pycryptodome/"
SRC_URI="
	https://github.com/Legrandin/pycryptodome/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2 Unlicense"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~x64-macos"
IUSE=""

DEPEND="
	dev-libs/gmp:0=
	>=dev-libs/libtomcrypt-1.18.2-r1:="
BDEPEND="
	virtual/python-cffi[${PYTHON_USEDEP}]"
RDEPEND="
	${DEPEND}
	${BDEPEND}
	!dev-python/pycrypto"

PATCHES=(
	"${FILESDIR}/pycryptodome-3.10.1-parallel-make.patch"
	"${FILESDIR}/pycryptodome-3.10.1-system-libtomcrypt.patch"
)

distutils_enable_tests setup.py

python_prepare_all() {
	# parallel make fixes
	#  Multiple targets were compiling the same file, setuptools doesn't
	#  understand this and you get race conditions where a file gets
	#  overwritten while it's linking. This makes the files look like separate
	#  files so this race won't happen
	ln src/blowfish.c src/blowfish_eks.c || die
	ln src/mont.c src/mont_math.c || die

	# make sure we're unbundling it correctly
	rm -r src/libtom || die

	distutils-r1_python_prepare_all
}
