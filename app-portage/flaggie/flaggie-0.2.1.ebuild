# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A smart CLI mangler for package.* files"
HOMEPAGE="https://github.com/mgorny/flaggie/"
SRC_URI="https://github.com/mgorny/flaggie/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"

python_install_all() {
	newbashcomp contrib/bash-completion/${PN}.bash-completion ${PN}
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn "Please denote that flaggie creates backups of your package.* files"
	ewarn "before performing each change through appending a single '~'."
	ewarn "If you'd like to keep your own backup of them, please use another"
	ewarn "naming scheme (or even better some VCS)."
	elog
	elog "bash-completion support requires:"
	elog "	app-shells/gentoo-bashcomp"
	has_version app-shells/gentoo-bashcomp && \
		elog "(installed already)"
}
