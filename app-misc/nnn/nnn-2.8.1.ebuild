# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="The missing terminal file browser for X"
HOMEPAGE="https://github.com/jarun/nnn"
SRC_URI="https://github.com/jarun/nnn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	tc-export CC
	sed -i -e '/strip/d' Makefile || die "sed failed"

}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install

	newbashcomp misc/auto-completion/bash/nnn-completion.bash nnn

	insinto /usr/share/fish/vendor_completions.d
	doins misc/auto-completion/fish/nnn.fish

	insinto /usr/share/zsh/site-functions
	doins misc/auto-completion/zsh/_nnn

	einstalldocs
}
