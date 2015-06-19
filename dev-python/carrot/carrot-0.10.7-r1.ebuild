# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/carrot/carrot-0.10.7-r1.ebuild,v 1.3 2015/03/08 23:41:22 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="http://github.com/ask/carrot/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-python/anyjson[${PYTHON_USEDEP}]
	>=dev-python/amqplib-0.6[${PYTHON_USEDEP}]"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
# Half of tests fail

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
