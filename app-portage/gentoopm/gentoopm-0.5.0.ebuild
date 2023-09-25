# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="
	https://github.com/projg2/gentoopm/
	https://pypi.org/project/gentoopm/
"
SRC_URI="
	https://github.com/projg2/gentoopm/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~mips ~ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.12.19[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	app-eselect/eselect-package-manager
"

distutils_enable_tests pytest
