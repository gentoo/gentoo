# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="f5d53239f7658f8e8fbaf02535cc369009c436d6"

inherit bash-completion-r1

DESCRIPTION="bash-completion scripts for tmux"
HOMEPAGE="https://github.com/imomaliev/tmux-bash-completion"
SRC_URI="https://github.com/imomaliev/tmux-bash-completion/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-misc/tmux-2.2
	app-shells/bash-completion
"

src_install() {
	default
	dobashcomp "${S}/completions/tmux"
}

pkg-postinst() {
	elog "Add the following line to ~/.bashrc to enable completions"
	elog
	elog "# source ${EPREFIX}/usr/share/bash-completion/completions/tmux"
}
