# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} pypy pypy3 )  # Do NOT add python3_4—see DESCRIPTION

inherit distutils-r1

DESCRIPTION="Python 3.4 Enum backported"
HOMEPAGE="https://pypi.python.org/pypi/enum34"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc"

DEPEND=""
RDEPEND=""

python_test() {
	"${PYTHON}" enum/test_enum.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local DOCS=( enum/doc/. enum/README enum/LICENSE )

	distutils-r1_python_install_all
}
