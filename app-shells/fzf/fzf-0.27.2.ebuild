# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="General-purpose command-line fuzzy finder, written in Golang"
HOMEPAGE="https://github.com/junegunn/fzf"

# For fancy versioning only. Bump on the next release!
MY_GIT_REV=e086f0b

EGO_SUM=(
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/gdamore/tcell v1.4.0"
	"github.com/gdamore/tcell v1.4.0/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.2.0"
	"github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-runewidth v0.0.7/go.mod"
	"github.com/mattn/go-runewidth v0.0.12"
	"github.com/mattn/go-runewidth v0.0.12/go.mod"
	"github.com/mattn/go-shellwords v1.0.11"
	"github.com/mattn/go-shellwords v1.0.11/go.mod"
	"github.com/rivo/uniseg v0.1.0/go.mod"
	"github.com/rivo/uniseg v0.2.0"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/saracen/walker v0.1.2"
	"github.com/saracen/walker v0.1.2/go.mod"
	"golang.org/x/sync v0.0.0-20200317015054-43a5402ce75a/go.mod"
	"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c"
	"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
	"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210403161142-5e06dd20ab57"
	"golang.org/x/sys v0.0.0-20210403161142-5e06dd20ab57/go.mod"
	"golang.org/x/term v0.0.0-20210317153231-de623e64d2a6"
	"golang.org/x/term v0.0.0-20210317153231-de623e64d2a6/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.6"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
)

go-module_set_globals

SRC_URI="
	https://github.com/junegunn/fzf/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}
"

LICENSE="MIT BSD-with-disclosure"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

src_prepare() {
	default
	sed -i 's/-s -w //' Makefile || die # bug 795225
}

src_compile() {
	emake PREFIX="${EPREFIX}"/usr VERSION=${PV} REVISION=${MY_GIT_REV} bin/${PN}
}

src_install() {
	dobin bin/${PN}
	doman man/man1/${PN}.1

	dobin bin/${PN}-tmux
	doman man/man1/${PN}-tmux.1

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/${PN}.vim

	insinto /usr/share/nvim/runtime/plugin
	doins plugin/${PN}.vim

	newbashcomp shell/completion.bash ${PN}

	insinto /usr/share/zsh/site-functions
	newins shell/completion.zsh _${PN}

	insinto /usr/share/fzf
	doins shell/key-bindings.bash
	doins shell/key-bindings.fish
	doins shell/key-bindings.zsh
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To add fzf support to your shell, make sure to use the right file"
		elog "from /usr/share/fzf."
		elog
		elog "For bash, add the following line to ~/.bashrc:"
		elog
		elog "	# source /usr/share/bash-completion/completions/fzf"
		elog "	# source /usr/share/fzf/key-bindings.bash"
		elog
		elog "Plugins for Vim and Neovim are installed to respective directories"
		elog "and will work out of the box."
		elog
		elog "For fzf support in tmux see fzf-tmux(1)."
	fi
}
