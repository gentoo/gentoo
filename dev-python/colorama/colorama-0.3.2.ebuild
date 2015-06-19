# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/colorama/colorama-0.3.2.ebuild,v 1.4 2015/04/08 08:05:29 mgorny Exp $

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
