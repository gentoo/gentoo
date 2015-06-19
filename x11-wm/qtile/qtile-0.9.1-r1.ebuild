# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/qtile/qtile-0.9.1-r1.ebuild,v 1.1 2015/02/26 01:17:14 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 virtualx

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/qtile/qtile.git"
	inherit git-r3
else
	SRC_URI="https://github.com/qtile/qtile/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A full-featured, hackable tiling window manager written in Python"
HOMEPAGE="http://qtile.org/"

LICENSE="MIT"
SLOT="0"
IUSE="test"
# docs require sphinxcontrib-blockdiag and sphinxcontrib-seqdiag

RDEPEND="x11-libs/pango
	>=dev-python/cairocffi-0.6[${PYTHON_USEDEP}]
	>=dev-python/cffi-0.8.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/xcffib-0.1.11[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/trollius[${PYTHON_USEDEP}]' 'python2*')
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		x11-base/xorg-server[kdrive]
	)
"

RESTRICT="test"

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	distutils-r1_python_install_all

	insinto /usr/share/xsessions
	doins resources/qtile.desktop

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}
}
