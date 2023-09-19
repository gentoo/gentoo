# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A generator for Rust/Cargo ebuilds written in Python"
HOMEPAGE="
	https://github.com/projg2/pycargoebuild/
	https://pypi.org/project/pycargoebuild/
"
SRC_URI="
	https://github.com/projg2/pycargoebuild/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64"

RDEPEND="
	dev-python/license-expression[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.9 3.10)
"

distutils_enable_tests pytest
