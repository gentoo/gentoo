# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Type hints for Numpy"
HOMEPAGE="https://pypi.org/project/nptyping/
	https://github.com/ramonhagenaars/nptyping"
SRC_URI="
	https://github.com/ramonhagenaars/nptyping/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/typish[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
