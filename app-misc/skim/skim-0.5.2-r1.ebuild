# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.4
ansi_term-0.10.2
atty-0.2.3
bitflags-1.0.1
cc-1.0.17
cfg-if-0.1.3
clap-2.28.0
env_logger-0.4.3
kernel32-sys-0.2.2
lazy_static-0.2.11
libc-0.2.42
log-0.3.8
memchr-2.0.1
nix-0.11.0
redox_syscall-0.1.32
redox_termios-0.1.1
regex-0.2.3
regex-syntax-0.4.1
shlex-0.1.1
strsim-0.6.0
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.4
time-0.1.38
unicode-width-0.1.4
unreachable-1.0.0
utf8-ranges-1.0.0
vec_map-0.8.0
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
"

inherit cargo

DESCRIPTION="a command-line fuzzy finder"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="tmux vim test"
RESTRICT="!test? ( test )"

DEPEND="virtual/rust"
RDEPEND="
	tmux? ( app-misc/tmux )
	vim? ( || ( app-editors/vim app-editors/gvim ) )
"

src_install() {
	cargo_src_install
	dodoc CHANGELOG.md README.md

	use tmux && dobin bin/sk-tmux

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins plugin/skim.vim
	fi

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto /usr/share/${PN}
	doins shell/{*.bash,*.zsh}
}
