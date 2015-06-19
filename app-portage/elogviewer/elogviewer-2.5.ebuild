# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/elogviewer/elogviewer-2.5.ebuild,v 1.1 2015/05/16 16:24:49 dolsen Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})
DISABLE_AUTOFORMATTING=true
inherit distutils-r1 eutils readme.gentoo

DESCRIPTION="Elog viewer for Gentoo"
HOMEPAGE="https://sourceforge.net/projects/elogviewer"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="|| (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		dev-python/PyQt4[${PYTHON_USEDEP},X]
		dev-python/pyside[${PYTHON_USEDEP},X] )
	>=sys-apps/portage-2.1
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python{2_7,3_3})
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOC_CONTENTS="In order to use this software, you need to activate
Portage's elog features.  Required is
	PORTAGE_ELOG_SYSTEM=\"save\"
and at least one of
	PORTAGE_ELOG_CLASSES=\"warn error info log qa\"
More information on the elog system can be found in /etc/make.conf.example

To operate properly this software needs the directory
${PORT_LOGDIR:-/var/log/portage}/elog created, belonging to group portage.
To start the software as a user, add yourself to the portage group."

src_install() {
	mv elogviewer.py elogviewer
	dobin elogviewer
	doman elogviewer.1
	make_desktop_entry ${PN} ${PN} ${PN} System
	readme.gentoo_src_install
}
