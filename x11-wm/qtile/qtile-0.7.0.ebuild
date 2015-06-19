# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/qtile/qtile-0.7.0.ebuild,v 1.2 2015/04/08 17:29:19 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://github.com/qtile/qtile.git"
	inherit git-r3
else
	SRC_URI="https://github.com/qtile/qtile/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="http://qtile.org/"

LICENSE="MIT"
SLOT="0"
IUSE="doc test"

RDEPEND=">=dev-python/pycairo-1.10.0-r4[xcb,${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	>=x11-libs/xpyb-1.3.1-r1[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/python-xlib[${PYTHON_USEDEP}]
		x11-base/xorg-server[kdrive]
	)"

# tests fail due to xauth errors from python-xlib
RESTRICT="test"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all

	insinto /usr/share/xsessions
	doins resources/qtile.desktop

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}
}
