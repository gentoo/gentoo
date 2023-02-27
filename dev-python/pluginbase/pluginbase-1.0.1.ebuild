# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Support library for building plugins sytems in Python"
HOMEPAGE="https://github.com/mitsuhiko/pluginbase"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_test() {
	cd tests || die
	distutils-r1_src_test
}
