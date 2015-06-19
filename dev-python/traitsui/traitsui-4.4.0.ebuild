# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/traitsui/traitsui-4.4.0.ebuild,v 1.5 2015/03/09 00:00:37 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Traits-capable user interfaces"
HOMEPAGE="https://github.com/enthought/traitsui"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/pyface[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

python_test() {
	export ETS_TOOLKIT=qt4
	export QT_API=pyqt
	VIRTUALX_COMMAND="nosetests -v" virtualmake

}
