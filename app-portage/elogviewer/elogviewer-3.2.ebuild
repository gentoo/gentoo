# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

DISABLE_AUTOFORMATTING=true

inherit desktop python-single-r1 readme.gentoo-r1

DESCRIPTION="Elog viewer for Gentoo"
HOMEPAGE="https://github.com/Synss/elogviewer"
SRC_URI="https://github.com/Synss/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~riscv x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

DOC_CONTENTS="In order to use this software, you need to activate
Portage's elog features.  Required is
	PORTAGE_ELOG_SYSTEM=\"save\"
and at least one of
	PORTAGE_ELOG_CLASSES=\"warn error info log qa\"
More information on the elog system can be found in
/usr/share/portage/config/make.conf.example

To operate properly this software needs the directory
${PORT_LOGDIR:-/var/log/portage}/elog created, belonging to group portage.
To start the software as a user, add yourself to the portage group."

src_compile() {
	rm -f Makefile
}

src_install() {
	python_newscript elogviewer.py elogviewer

	make_desktop_entry ${PN} ${PN} ${PN} System

	doman elogviewer.1
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	ewarn "The elogviewer's configuration file is now saved in:"
	ewarn "~/.config/elogviewer/ (was ~/.config/Mathias\ Laurin/)."
	ewarn "Please migrate any user specific settings to the new config file."
}
