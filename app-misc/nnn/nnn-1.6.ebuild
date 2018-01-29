# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="The missing terminal file browser for X"
HOMEPAGE="https://github.com/jarun/nnn"
SRC_URI="https://github.com/jarun/nnn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion fish-completion zsh-completion"

DEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}
		fish-completion? ( app-shells/fish )
		zsh-completion? ( app-shells/zsh )"

src_prepare() {
	default
	tc-export CC
	sed -i -e '/strip/d' Makefile || die "sed failed"

}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install

	use bash-completion &&
		newbashcomp scripts/auto-completion/bash/nnn-completion.bash nnn

	if use fish-completion; then
		insinto /usr/share/fish/completions
		doins scripts/auto-completion/fish/nnn.fish
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins scripts/auto-completion/zsh/_nnn
	fi

	einstalldocs
}
