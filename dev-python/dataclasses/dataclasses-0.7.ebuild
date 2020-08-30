# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="A backport of the dataclasses module for Python 3.6"
HOMEPAGE="
	https://pypi.org/project/dataclasses/
	https://github.com/ericvsmith/dataclasses"
SRC_URI="
	mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~x86"

src_test() {
	cd test || die
	distutils-r1_src_test
}

distutils_enable_tests unittest
