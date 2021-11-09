# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Yet another URL library"
HOMEPAGE="https://github.com/aio-libs/yarl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/alabaster

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-test-without-coverage.patch
)

python_test() {
	cd tests || die
	# broken by CPython CVE fix
	epytest \
		--deselect tests/test_url_query.py::test_semicolon_as_separator
}
