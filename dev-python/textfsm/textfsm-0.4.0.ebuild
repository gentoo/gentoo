# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Python module for parsing semi-structured text into python tables."
HOMEPAGE="https://github.com/google/textfsm/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="examples"

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
