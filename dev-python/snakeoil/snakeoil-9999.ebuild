# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/pkgcore/snakeoil.git
		https://github.com/pkgcore/snakeoil.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
	inherit pypi
fi

DESCRIPTION="misc common functionality and useful optimizations"
HOMEPAGE="https://github.com/pkgcore/snakeoil"

LICENSE="BSD BSD-2 MIT"
SLOT="0"

RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/flit-core-3.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
