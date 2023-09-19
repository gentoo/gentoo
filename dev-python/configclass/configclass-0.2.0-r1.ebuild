# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A Python to class to hold configuration values"
HOMEPAGE="
	https://github.com/schettino72/configclass/
	https://pypi.org/project/configclass/
"
SRC_URI="
	https://github.com/schettino72/configclass/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-python/mergedict-0.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
