# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="an easy whitelist-based HTML-sanitizing tool"
HOMEPAGE="https://github.com/mozilla/bleach https://pypi.org/project/bleach/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
