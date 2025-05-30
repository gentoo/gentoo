# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/setuptools-scm-8.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-vcs/git
	)
"

distutils_enable_tests pytest
