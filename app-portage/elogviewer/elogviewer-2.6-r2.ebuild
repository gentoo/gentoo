# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )

DISABLE_AUTOFORMATTING=true

inherit python-single-r1 eutils readme.gentoo-r1

DESCRIPTION="Elog viewer for Gentoo"
HOMEPAGE="https://sourceforge.net/projects/elogviewer"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	|| (
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		dev-python/PyQt4[${PYTHON_USEDEP},X]
		dev-python/pyside[${PYTHON_USEDEP},X]
	)
	>=sys-apps/portage-2.1
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python{2_7,3_3})
	!dev-python/PyQt5[-gui]
	!dev-python/PyQt5[-widgets]
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
	python_newscript elogviewer.py elogviewer

	make_desktop_entry ${PN} ${PN} ${PN} System

	doman elogviewer.1
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
