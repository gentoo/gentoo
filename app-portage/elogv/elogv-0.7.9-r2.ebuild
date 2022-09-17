# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7,8,9,10} pypy3 )
PYTHON_REQ_USE="ncurses"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Curses based utility to parse the contents of elogs created by Portage"
HOMEPAGE="https://gitweb.gentoo.org/proj/elogv.git/"
SRC_URI="https://github.com/gentoo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
PLOCALES=( "de" "es" "it" "pl" )
IUSE="${PLOCALES[*]/#/l10n_}"

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( README )

src_install() {
	distutils-r1_src_install

	elog 'Deleting unwanted language files...'
	for i in ${PLOCALES[@]}; do
		if use "l10n_${i}"; then
			# Keep and fix man page filename (bug #869905)
			mv "${ED}"/usr/share/man/${i}/man1/${PN}.1{.${i},} || die
		else
			rm -r "${ED}"/usr/share/{locale,man}/"${i}" || die
			elog "- Language \"${i}\" deleted"
		fi
	done
}

pkg_postinst() {
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "		 PORTAGE_ELOG_SYSTEM=\"save\" "
	elog "and at least one out of "
	elog "		 PORTAGE_ELOG_CLASSES=\"warn error info log qa\""
	elog "More information on the elog system can be found"
	elog "in ${EPREFIX}/usr/share/portage/config/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "${PORT_LOGDIR:-${EPREFIX}/var/log/portage}/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
