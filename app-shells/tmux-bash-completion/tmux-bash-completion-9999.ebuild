# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1 git-r3

DESCRIPTION="bash-completion scripts for tmux"
HOMEPAGE="https://github.com/imomaliev/tmux-bash-completion"
EGIT_REPO_URI="https://github.com/imomaliev/tmux-bash-completion.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=app-misc/tmux-2.2
	app-shells/bash-completion
	"
RDEPEND="${DEPEND}"

src_install() {
	default
	dobashcomp "${S}"/completions/tmux
}
