# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module readme.gentoo-r1 shell-completion

DESCRIPTION="General-purpose command-line fuzzy finder, written in Golang"
HOMEPAGE="https://github.com/junegunn/fzf"

MY_GIT_REV=2ab923f3ae04d5e915e5ff4a9cd3bd515bfd1ea5

SRC_URI="https://github.com/junegunn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT BSD-with-disclosure"
# Dependent licenses
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

src_compile() {
	local go_ldflags=(
		-X main.version=${PV}
		-X main.revision=${MY_GIT_REV:0:7}
	)
	ego build -trimpath -ldflags "${go_ldflags[*]}" -o bin/${PN} .
}

src_test() {
	ego test -v github.com/junegunn/fzf/src{,/algo,/tui,/util}
}

src_install() {
	dobin bin/${PN}
	doman man/man1/${PN}.1

	dobin bin/${PN}-tmux
	doman man/man1/${PN}-tmux.1

	newbashcomp shell/completion.bash ${PN}
	newzshcomp shell/completion.zsh _${PN}

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/${PN}.vim

	insinto /usr/share/nvim/runtime/plugin
	doins plugin/${PN}.vim

	insinto /usr/share/fzf
	doins shell/key-bindings.bash
	doins shell/key-bindings.fish
	doins shell/key-bindings.zsh

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
