# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A simple, safe single expression evaluator library"
HOMEPAGE="https://github.com/danthedeckie/simpleeval"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests setup.py

src_prepare() {
	sed -e '/use_2to3/d' -i setup.py || die
	distutils-r1_src_prepare
}
