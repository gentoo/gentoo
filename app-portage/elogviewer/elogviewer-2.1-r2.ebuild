# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=(python{2_7,3_3,3_4})

inherit distutils-r1

DESCRIPTION="Elog viewer for Gentoo"
HOMEPAGE="https://sourceforge.net/projects/elogviewer"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="
		|| ( dev-python/PyQt4[${PYTHON_USEDEP},X]
			dev-python/pyside[${PYTHON_USEDEP},X] )
		>=sys-apps/portage-2.1
		"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"

src_install() {
	mv elogviewer.py elogviewer
	dobin elogviewer
	doman elogviewer.1
	dodoc LICENSE.TXT
}

pkg_postinst() {
	elog
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "		 PORTAGE_ELOG_SYSTEM=\"save\" "
	elog "and at least one of "
	elog "		 PORTAGE_ELOG_CLASSES=\"warn error info log qa\""
	elog "More information on the elog system can be found"
	elog "in /etc/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "${PORT_LOGDIR:-/var/log/portage}/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
