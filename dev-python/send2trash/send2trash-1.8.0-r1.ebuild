# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Sends files to the Trash (or Recycle Bin)"
HOMEPAGE="
	https://github.com/arsenetar/send2trash/
	https://pypi.org/project/Send2Trash/
"
SRC_URI="
	https://github.com/arsenetar/send2trash/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
