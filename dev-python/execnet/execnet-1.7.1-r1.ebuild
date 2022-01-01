# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Rapid multi-Python deployment"
HOMEPAGE="https://codespeak.net/execnet/
	https://pypi.org/project/execnet/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-macos"

RDEPEND=">=dev-python/apipkg-1.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/execnet-1.7.1-tests.patch"
)

distutils_enable_sphinx doc
distutils_enable_tests pytest

python_prepare_all() {
	# Remove doctest that access an i'net site
	rm doc/example/test_info.rst || die

	sed -i -r 's:(,[[:space:]]*|)"eventlet":: ; s:(,[[:space:]]*|)"gevent"(,|)::' \
		testing/conftest.py || die

	# get rid of setuptools_scm dep
	sed -i -r "s:use_scm_version=.+,:version='${PV}',: ; s:\"setuptools_scm\"::" \
		setup.py || die

	printf -- '__version__ = "%s"\nversion = "%s"\n' "${PV}" "${PV}" > \
		execnet/_version.py || die

	distutils-r1_python_prepare_all
}
