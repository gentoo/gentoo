# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Functionality for types"
HOMEPAGE="https://pypi.org/project/typish/
	https://github.com/ramonhagenaars/typish"
SRC_URI="
	https://github.com/ramonhagenaars/typish/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/nptyping[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
