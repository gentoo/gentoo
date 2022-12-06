# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python implementation of the patiencediff algorithm"
HOMEPAGE="
	https://github.com/breezy-team/patiencediff/
	https://pypi.org/project/patiencediff/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests unittest

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	eunittest
}
