# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 git-r3

DESCRIPTION="bash-completion scripts for tmux"
HOMEPAGE="https://github.com/imomaliev/tmux-bash-completion"
EGIT_REPO_URI="https://github.com/imomaliev/tmux-bash-completion.git"

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	>=app-misc/tmux-2.2
	app-shells/bash-completion
"
RDEPEND="${DEPEND}"

src_install() {
	default
	dobashcomp "${S}"/completions/tmux
}
