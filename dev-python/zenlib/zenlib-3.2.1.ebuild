# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Useful python decorators and utilities"
HOMEPAGE="https://github.com/desultory/zenlib/"
SRC_URI="
	https://github.com/desultory/zenlib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

distutils_enable_tests unittest

python_test() {
	CI=true eunittest tests  # Set CI=true to disable namespace module tests and imports
}
