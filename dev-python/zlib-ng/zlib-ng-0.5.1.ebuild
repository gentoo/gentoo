# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=python-zlib-ng-${PV}
DESCRIPTION="Drop-in replacement for zlib and gzip modules using zlib-ng"
HOMEPAGE="
	https://github.com/pycompression/python-zlib-ng/
	https://pypi.org/project/zlib-ng/
"
# no tests in sdist, as of 0.5.1
# same upstream as dev-python/isal, so let's see how that report goes:
# https://github.com/pycompression/python-isal/issues/231
SRC_URI="
	https://github.com/pycompression/python-zlib-ng/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~riscv ~s390 ~x86"

DEPEND="
	sys-libs/zlib-ng:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_configure() {
	export PYTHON_ZLIB_NG_LINK_DYNAMIC=1

	# why people can't use setuptools-scm...
	sed -i -e '/versioningit/d' setup.py || die
	sed -i -e 's/versioningit/ignoreme/' pyproject.toml || die
	echo "[metadata]" >> setup.cfg || die
	echo "version = ${PV}" >> setup.cfg || die
	echo "__version__ = '${PV}'" > src/zlib_ng/_version.py || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
