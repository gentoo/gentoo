# Copyright 2017-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

RUST_MIN_VER="1.91.0"

inherit cargo optfeature shell-completion

DESCRIPTION="Command-line fuzzy finder"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="
	https://github.com/skim-rs/skim/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 LGPL-3 MIT Unicode-3.0 Unicode-DFS-2016 WTFPL-2 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="test? ( app-misc/tmux )"

QA_FLAGS_IGNORED="usr/bin/sk"

DOCS=(
	ARCHITECTURE.md
	CHANGELOG.md
	README.md
)

src_configure() {
	myfeatures=( cli )
	cargo_src_configure --no-default-features
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install

	einstalldocs
	doman manpages/man1/*

	dobin bin/sk-tmux
	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/skim.vim

	# install shell keybindings
	insinto "/usr/share/${PN}"
	doins shell/key-bindings.*

	newbashcomp shell/completion.bash sk
	newzshcomp shell/completion.fish sk.fish
	newzshcomp shell/completion.zsh _sk
}

pkg_postinst() {
	optfeature "sk-tmux integration" app-misc/tmux
	optfeature "vim plugin integration" app-editors/vim app-editors/gvim
}
