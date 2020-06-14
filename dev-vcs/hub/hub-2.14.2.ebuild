# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"
SRC_URI="https://github.com/github/hub/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-vcs/git-1.7.3"

src_compile() {
	emake bin/hub man-pages
}

src_test() {
	emake test
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
	doman share/man/man1/*.1

	newbashcomp etc/${PN}.bash_completion.sh ${PN}

	insinto /usr/share/vim/vimfiles
	doins -r share/vim/vimfiles/*
	insinto /usr/share/zsh/site-functions
	newins etc/hub.zsh_completion _${PN}
}
