# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.14
ansi_term-0.11.0
arrayref-0.3.6
arrayvec-0.5.1
atty-0.2.14
autocfg-1.0.1
base64-0.12.3
beef-0.4.4
bitflags-1.2.1
blake2b_simd-0.5.10
cc-1.0.61
cfg-if-0.1.10
chrono-0.4.19
clap-2.33.3
constant_time_eq-0.1.5
crossbeam-0.7.3
crossbeam-channel-0.4.4
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.3
crossbeam-utils-0.7.2
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
defer-drop-1.0.1
derive_builder-0.9.0
derive_builder_core-0.9.0
dirs-2.0.2
dirs-sys-0.3.5
either-1.6.1
env_logger-0.6.2
fnv-1.0.7
fuzzy-matcher-0.3.7
getrandom-0.1.15
hermit-abi-0.1.17
humantime-1.3.0
ident_case-1.0.1
lazy_static-1.4.0
libc-0.2.79
log-0.4.11
maybe-uninit-2.0.0
memchr-2.3.3
memoffset-0.5.6
nix-0.14.1
num_cpus-1.13.0
num-integer-0.1.43
num-traits-0.2.12
once_cell-1.4.1
proc-macro2-1.0.24
quick-error-1.2.3
quote-1.0.7
rayon-1.4.1
rayon-core-1.8.1
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.4.1
regex-syntax-0.6.20
rust-argon2-0.8.2
scopeguard-1.1.0
shlex-0.1.1
strsim-0.8.0
strsim-0.9.3
syn-1.0.44
term-0.6.1
termcolor-1.1.0
textwrap-0.11.0
thread_local-1.0.1
time-0.1.44
timer-0.2.0
tuikit-0.4.2
unicode-width-0.1.8
unicode-xid-0.2.1
utf8parse-0.1.1
vec_map-0.8.2
void-1.0.2
vte-0.3.3
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Command-line fuzzy finder"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
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
