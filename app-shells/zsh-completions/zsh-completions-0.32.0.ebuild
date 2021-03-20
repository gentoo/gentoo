# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zsh-users/zsh-completions.git"
else
	SRC_URI="https://github.com/zsh-users/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~sparc ~x86 ~x64-macos"
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
