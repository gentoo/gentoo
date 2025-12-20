# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="
	https://pypi.org/project/httplib2/
	https://github.com/httplib2/httplib2/
"
SRC_URI="
	https://github.com/httplib2/httplib2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-libs/openssl
		dev-python/cryptography[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-timeout )
# note: tests are racy with xdist
distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	# remove bundled certs, we always want system certs via certifi
	rm httplib2/cacerts.txt || die
	distutils-r1_src_prepare
}
