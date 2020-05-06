# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="a python parser that supports error recovery and round-trip parsing"
HOMEPAGE="https://github.com/davidhalter/parso https://pypi.org/project/parso/"
SRC_URI="https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# tests rely on specific exception messages and fail occasionally
	# upstream suggested skipping them
	rm test/test_python_errors.py || die

	distutils-r1_src_prepare
}
