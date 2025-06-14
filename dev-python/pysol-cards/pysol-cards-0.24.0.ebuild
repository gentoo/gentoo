# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Deal PySol FreeCell cards"
HOMEPAGE="
	https://github.com/shlomif/pysol_cards/
	https://pypi.org/project/pysol-cards/
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

distutils_enable_tests unittest

python_test() {
	eunittest -s tests
}
