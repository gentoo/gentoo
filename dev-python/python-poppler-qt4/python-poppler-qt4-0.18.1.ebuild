# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-poppler-qt4/python-poppler-qt4-0.18.1.ebuild,v 1.1 2014/10/27 05:59:08 ssuominen Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="A python binding for libpoppler-qt4"
HOMEPAGE="http://code.google.com/p/python-poppler-qt4/"
SRC_URI="http://github.com/wbsoft/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/poppler:=[qt4]
	dev-python/PyQt4[${PYTHON_USEDEP}]
	>=dev-python/sip-4.9.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-update_for_new_PyQt4_build.patch
	distutils-r1_src_prepare
}
