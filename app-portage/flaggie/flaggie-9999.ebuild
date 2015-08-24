# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit bash-completion-r1 distutils-r1

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"
inherit git-r3
#endif

DESCRIPTION="A smart CLI mangler for package.* files"
HOMEPAGE="https://bitbucket.org/mgorny/flaggie/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"

#if LIVE
KEYWORDS=
SRC_URI=
#endif

python_install_all() {
	newbashcomp contrib/bash-completion/${PN}.bash-completion ${PN}
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn "Please note that flaggie creates backups of your package.* files"
	ewarn "before performing each change through appending a single '~'."
	ewarn "If you'd like to keep your own backup of them, please use another"
	ewarn "naming scheme (or even better some VCS)."
	if ! has_version app-shells/gentoo-bashcomp; then
		elog
		elog "If you want to use bash-completion, you need to install:"
		elog "	app-shells/gentoo-bashcomp"
	fi
}
