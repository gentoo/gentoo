# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A simple argparse wrapper"
HOMEPAGE="
	https://pythonhosted.org/argh/
	https://github.com/neithere/argh/
	https://pypi.org/project/argh/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	test? (
		dev-python/iocapture[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/neithere/argh/commit/699568ad674c5ea26d361202c386a8a8a82ec8ad
	"${FILESDIR}/${P}-py314.patch"
)
