# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit distutils-r1

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="https://pypi.python.org/pypi/decorator https://code.google.com/p/micheles/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-test-failure-exit.patch
)

python_test() {
	local t=documentation.py
	[[ ${EPYTHON} == python3* ]] && t=documentation3.py

	"${PYTHON}" ${t} || die "Tests fail with ${EPYTHON}"
}
