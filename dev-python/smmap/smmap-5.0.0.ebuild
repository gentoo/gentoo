# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A pure Python implementation of a sliding window memory map manager"
HOMEPAGE="
	https://pypi.org/project/smmap/
	https://github.com/gitpython-developers/smmap/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
SLOT="0"

distutils_enable_tests unittest
