# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

# Git revision of the release tag. Please bump along with the ebuild
# version.
MY_GIT_REVISION=334a4fa

EGO_SUM=(
	"github.com/DATA-DOG/go-sqlmock v1.3.3/go.mod"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/gdamore/tcell v1.3.0"
	"github.com/gdamore/tcell v1.3.0/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.2"
	"github.com/lucasb-eyer/go-colorful v1.0.2/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.3"
	"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/mattn/go-runewidth v0.0.4/go.mod"
	"github.com/mattn/go-runewidth v0.0.8"
	"github.com/mattn/go-runewidth v0.0.8/go.mod"
	"github.com/mattn/go-shellwords v1.0.9"
	"github.com/mattn/go-shellwords v1.0.9/go.mod"
	"github.com/saracen/walker v0.0.0-20191201085201-324a081bae7e"
	"github.com/saracen/walker v0.0.0-20191201085201-324a081bae7e/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200128174031-69ecbb4d6d5d"
	"golang.org/x/crypto v0.0.0-20200128174031-69ecbb4d6d5d/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756"
	"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20200202164722-d101bd2416d5"
	"golang.org/x/sys v0.0.0-20200202164722-d101bd2416d5/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20191011211836-4c025a95b26e"
	"golang.org/x/tools v0.0.0-20191011211836-4c025a95b26e/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
)

go-module_set_globals

DESCRIPTION="A command-line fuzzy finder"
HOMEPAGE="https://github.com/junegunn/fzf"
SRC_URI="https://github.com/junegunn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
			${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tmux"

RDEPEND="tmux? ( app-misc/tmux )"

PATCHES=( "${FILESDIR}/${P}-fix-ld-flags-processing.patch" )

src_compile() {
	emake PREFIX="${EPREFIX}/usr" REVISION="${MY_GIT_REVISION}" bin/${PN}
}

src_install() {
	dobin bin/${PN}
	doman man/man1/${PN}.1

	if use tmux; then
		dobin bin/${PN}-tmux
		doman man/man1/${PN}-tmux.1
	fi

	einstalldocs

	newbashcomp shell/completion.bash ${PN}

	insinto /usr/share/zsh/site-functions
	newins shell/completion.zsh _${PN}

	insinto /usr/share/${PN}
	doins shell/key-bindings.bash
	doins shell/key-bindings.fish
	doins shell/key-bindings.zsh

	insinto /usr/share/nvim/runtime/plugin
	doins plugin/${PN}.vim
	insinto /usr/share/nvim/runtime/doc
	doins doc/${PN}.txt

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/${PN}.vim
	insinto /usr/share/vim/vimfiles/doc
	doins doc/${PN}.txt
}
