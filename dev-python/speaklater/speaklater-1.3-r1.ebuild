# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Lazy strings for Python"
HOMEPAGE="https://github.com/mitsuhiko/speaklater"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

python_configure_all() {
	# https://github.com/mitsuhiko/speaklater/issues/2
	2to3 -n -w --no-diffs ${PN}.py || die
	2to3 -d -n -w --no-diffs ${PN}.py || die
	# fix unicode in doctests
	sed -ri "s/(^ {4}l?)u'/\1'/" ${PN}.py || die
}

python_test() {
	"${EPYTHON}" -m doctest -v speaklater.py ||
		die "tests failed with ${EPYTHON}"
}
