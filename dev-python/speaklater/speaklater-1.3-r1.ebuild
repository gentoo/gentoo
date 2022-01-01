# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..9} pypy )
inherit distutils-r1

DESCRIPTION="Lazy strings for Python"
HOMEPAGE="https://github.com/mitsuhiko/speaklater"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

python_prepare() {
	# https://github.com/mitsuhiko/speaklater/issues/2
	if python_is_python3; then
		2to3 -n -w --no-diffs ${PN}.py || die
		2to3 -d -n -w --no-diffs ${PN}.py || die
		# fix unicode in doctests
		sed -ri "s/(^ {4}l?)u'/\1'/" ${PN}.py || die
	fi
}

python_test() {
	"${EPYTHON}" -m doctest -v speaklater.py ||
		die "tests failed with ${EPYTHON}"
}
