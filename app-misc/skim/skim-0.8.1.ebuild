# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.3
ansi_term-0.11.0
arrayref-0.3.6
arrayvec-0.4.10
arrayvec-0.5.1
atty-0.2.11
autocfg-0.1.7
base64-0.11.0
bitflags-1.0.4
blake2b_simd-0.5.10
cc-1.0.31
cfg-if-0.1.7
chrono-0.4.6
clap-2.32.0
constant_time_eq-0.1.5
crossbeam-0.7.3
crossbeam-channel-0.4.0
crossbeam-deque-0.2.0
crossbeam-deque-0.7.2
crossbeam-epoch-0.3.1
crossbeam-epoch-0.8.0
crossbeam-queue-0.2.1
crossbeam-utils-0.2.2
crossbeam-utils-0.7.0
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
derive_builder-0.9.0
derive_builder_core-0.9.0
dirs-2.0.2
dirs-sys-0.3.4
either-1.5.1
env_logger-0.6.1
fnv-1.0.6
fuzzy-matcher-0.3.4
getrandom-0.1.6
humantime-1.2.0
ident_case-1.0.1
lazy_static-1.3.0
libc-0.2.58
log-0.4.6
memchr-2.2.0
memoffset-0.2.1
memoffset-0.5.3
nix-0.14.0
nodrop-0.1.13
num-integer-0.1.39
num-traits-0.2.6
num_cpus-1.10.0
proc-macro2-1.0.6
quick-error-1.2.2
quote-1.0.2
rayon-1.0.3
rayon-core-1.4.1
redox_syscall-0.1.51
redox_termios-0.1.1
redox_users-0.3.4
regex-1.1.6
regex-syntax-0.6.6
rust-argon2-0.7.0
rustc_version-0.2.3
scopeguard-0.3.3
scopeguard-1.0.0
semver-0.9.0
semver-parser-0.7.0
shlex-0.1.1
skim-0.8.1
spin-0.5.2
strsim-0.7.0
strsim-0.9.3
syn-1.0.11
term-0.6.1
termcolor-1.0.4
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
thread_local-1.0.0
time-0.1.42
timer-0.2.0
tuikit-0.3.2
ucd-util-0.1.3
unicode-width-0.1.5
unicode-xid-0.2.0
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
