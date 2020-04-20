# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

PDFS_COMMIT=d646009a0e3e71daf13a52ab1029e2230920ebf4
DESCRIPTION="PDF file reader/writer library"
HOMEPAGE="https://github.com/pmaupin/pdfrw"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? (
		https://github.com/pmaupin/static_pdfs/archive/${PDFS_COMMIT}.tar.gz
			-> pdfrw-static_pdfs-${PDFS_COMMIT}.tar.gz
	)"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ppc ppc64 sparc x86"

BDEPEND="
	test? ( dev-python/reportlab[${PYTHON_USEDEP}] )"

# unittest would be sufficient but its output is unreadable
distutils_enable_tests pytest

src_unpack() {
	default
	if use test; then
		mv "static_pdfs-${PDFS_COMMIT}"/* "${P}"/tests/static_pdfs/ || die
	fi
}

src_prepare() {
	# broken upstream (sensitive to reportlab version?)
	sed -e 's:test_rl1_platypus:_&:' \
		-i tests/test_examples.py || die
	# fails with py3
	sed -e '/repaginate\/7037/s:dd41b0104f185206b51e7ffe5b07d261:skip:' \
		-i tests/expected.txt || die

	distutils-r1_src_prepare
}

src_test() {
	cd tests || die
	distutils-r1_src_test
}
