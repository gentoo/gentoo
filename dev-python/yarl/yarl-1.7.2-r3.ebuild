# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Yet another URL library"
HOMEPAGE="
	https://github.com/aio-libs/yarl/
	https://pypi.org/project/yarl/
"
SRC_URI="
	https://github.com/aio-libs/yarl/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/alabaster

src_configure() {
	> .install-cython || die
	emake cythonize
}

python_test() {
	cd tests || die
	epytest --override-ini=addopts=
}
