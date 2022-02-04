# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A mutable set that remembers the order of its entries"
HOMEPAGE="https://github.com/rspeer/ordered-set"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest
