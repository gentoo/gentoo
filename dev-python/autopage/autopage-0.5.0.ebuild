# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A library to provide automatic paging for console output"
HOMEPAGE="
	https://pypi.org/project/autopage/
	https://github.com/zaneb/autopage/"
SRC_URI="
	https://github.com/zaneb/autopage/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc64 ~s390 sparc x86"

BDEPEND="
	test? ( dev-python/fixtures[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

python_test() {
	unset LESS PAGER
	eunittest
}
