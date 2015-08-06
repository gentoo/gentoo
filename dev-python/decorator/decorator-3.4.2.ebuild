# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/decorator/decorator-3.4.2.ebuild,v 1.3 2015/08/06 11:54:47 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit distutils-r1

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="http://pypi.python.org/pypi/decorator http://code.google.com/p/micheles/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
# This release is missing no less than 8 files

#python_test() {
#	local t=documentation.py
#	python_is_python3 && t=documentation3.py
#
#	"${PYTHON}" ${t} || die "Tests fail with ${EPYTHON}"
#}
