# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh-completions/zsh-completions-9999.ebuild,v 1.2 2015/06/30 18:12:51 mrueg Exp $

EAPI=5

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zsh-users/zsh-completions.git"
else
	SRC_URI="https://github.com/zsh-users/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Additional completion definitions for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-completions"

LICENSE="BSD"
SLOT="0"

RDEPEND="app-shells/zsh"

src_install() {
	insinto /usr/share/zsh/site-functions
	doins src/_*
}

pkg_postinst() {
	elog
	elog "If you happen to compile your functions, you may need to delete"
	elog "~/.zcompdump{,.zwc} and recompile to make the new completions available"
	elog "to your shell."
	elog
}
