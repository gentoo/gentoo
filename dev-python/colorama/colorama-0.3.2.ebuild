# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Makes ANSI escape character sequences for producing colored terminal text & cursor positioning"
HOMEPAGE="http://code.google.com/p/colorama/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

python_install_all() {
	use examples && local EXAMPLES=( demos/. )
	distutils-r1_python_install_all
}
