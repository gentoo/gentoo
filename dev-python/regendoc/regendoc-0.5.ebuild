# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{5,6} pypy3 )

inherit distutils-r1

MY_PN="RegenDoc"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Check/update simple file/shell examples in documentation"
HOMEPAGE="https://pypi.org/project/RegenDoc/
	https://bitbucket.org/pytest-dev/regendoc/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
