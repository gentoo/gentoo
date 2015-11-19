# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Makes ANSI escape character sequences for producing colored terminal text & cursor positioning"
HOMEPAGE="https://code.google.com/p/colorama/ https://pypi.python.org/pypi/colorama https://github.com/tartley/colorama"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

python_install_all() {
	use examples && local EXAMPLES=( demos/. )
	distutils-r1_python_install_all
}
