# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Hatch plugin for versioning with your preferred VCS"
HOMEPAGE="
	https://pypi.org/project/hatch-vcs/
	https://github.com/ofek/hatch-vcs/
"
SRC_URI="
	https://github.com/ofek/hatch-vcs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/setuptools_scm-6.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-vcs/git
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-Work-with-setuptools_scm-7.1-fix-25-26.patch
)

distutils_enable_tests pytest
