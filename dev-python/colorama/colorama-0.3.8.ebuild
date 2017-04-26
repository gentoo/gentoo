# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="ANSI escape character sequences for colored terminal text & cursor positioning"
HOMEPAGE="
	https://pypi.python.org/pypi/colorama
	https://github.com/tartley/colorama"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r demos/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
