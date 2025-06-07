# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=python-isal-${PV}
DESCRIPTION="Faster zlib and gzip via the ISA-L library"
HOMEPAGE="
	https://github.com/pycompression/python-isal/
	https://pypi.org/project/isal/
"
# no tests in sdist, as of 1.7.2
# https://github.com/pycompression/python-isal/issues/231
SRC_URI="
	https://github.com/pycompression/python-isal/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~riscv ~s390 ~x86"

DEPEND="
	dev-libs/isa-l:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/test[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_configure() {
	export PYTHON_ISAL_LINK_DYNAMIC=1

	# why people can't use setuptools-scm...
	sed -i -e '/versioningit/d' setup.py || die
	sed -i -e 's/versioningit/ignoreme/' pyproject.toml || die
	# it is an noeol file...
	echo >> setup.cfg || die
	echo "version = ${PV}" >> setup.cfg || die
	echo "__version__ = '${PV}'" > src/isal/_version.py || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
