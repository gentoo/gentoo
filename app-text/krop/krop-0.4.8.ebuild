# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/krop/krop-0.4.8.ebuild,v 1.1 2015/07/13 22:23:57 mrueg Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="A tool to crop PDF files"
HOMEPAGE="http://arminstraub.com/software/krop"
SRC_URI="http://arminstraub.com/downloads/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/python-poppler-qt4[${PYTHON_USEDEP}]
	dev-python/pyPdf[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	domenu "${WORKDIR}/${P}/${PN}.desktop"
}
