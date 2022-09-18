# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Check Portage's VDB for internal inconsistency on ELF metadata"
HOMEPAGE="https://github.com/thesamesam/recover-broken-vdb"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thesamesam/recover-broken-vdb.git"
else
	SRC_URI="https://github.com/thesamesam/recover-broken-vdb/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"

# Require latest version of pax-utils to avoid users breaking their systems again
# The tool itself works fine with older versions
RDEPEND="
	>=app-misc/pax-utils-1.3.3
	sys-apps/file
	$(python_gen_cond_dep 'sys-apps/portage[${PYTHON_USEDEP}]')
"
