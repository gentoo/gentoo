# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.3
ansi_term-0.11.0
arrayvec-0.4.10
atty-0.2.11
bitflags-1.0.4
byteorder-1.3.1
cc-1.0.31
cfg-if-0.1.7
chrono-0.4.6
clap-2.32.0
crossbeam-deque-0.2.0
crossbeam-epoch-0.3.1
crossbeam-utils-0.2.2
darling-0.8.6
darling_core-0.8.6
darling_macro-0.8.6
derive_builder-0.7.1
derive_builder_core-0.4.1
either-1.5.1
env_logger-0.6.1
fnv-1.0.6
fuzzy-matcher-0.2.1
humantime-1.2.0
ident_case-1.0.1
lazy_static-1.3.0
libc-0.2.58
log-0.4.6
memchr-2.2.0
memoffset-0.2.1
nix-0.14.0
nodrop-0.1.13
num-integer-0.1.39
num-traits-0.2.6
num_cpus-1.10.0
proc-macro2-0.4.27
quick-error-1.2.2
quote-0.6.11
rayon-1.0.3
rayon-core-1.4.1
redox_syscall-0.1.51
redox_termios-0.1.1
regex-1.1.6
regex-syntax-0.6.6
scopeguard-0.3.3
shlex-0.1.1
skim-0.6.9
strsim-0.7.0
syn-0.15.29
term-0.5.1
termcolor-1.0.4
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
time-0.1.42
timer-0.2.0
tuikit-0.2.9
ucd-util-0.1.3
unicode-width-0.1.5
unicode-xid-0.1.0
utf8-ranges-1.0.2
utf8parse-0.1.1
vec_map-0.8.1
void-1.0.2
vte-0.3.3
winapi-0.3.6
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
"

inherit cargo

DESCRIPTION="Command-line fuzzy finder"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="tmux vim"

RDEPEND="
	tmux? ( app-misc/tmux )
	vim? ( || ( app-editors/vim app-editors/gvim ) )
"

QA_FLAGS_IGNORED="usr/bin/sk"

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

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
