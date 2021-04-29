# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.15
ansi_term-0.11.0
arrayref-0.3.6
arrayvec-0.5.2
atty-0.2.14
autocfg-1.0.1
base-x-0.2.8
base64-0.13.0
beef-0.5.0
bitflags-1.2.1
blake2b_simd-0.5.11
bumpalo-3.4.0
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
const_fn-0.4.4
constant_time_eq-0.1.5
crossbeam-0.8.0
crossbeam-channel-0.4.4
crossbeam-channel-0.5.0
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.1
crossbeam-queue-0.3.1
crossbeam-utils-0.7.2
crossbeam-utils-0.8.1
darling-0.10.3
darling_core-0.10.3
darling_macro-0.10.3
defer-drop-1.0.1
derive_builder-0.9.0
derive_builder_core-0.9.0
dirs-2.0.2
dirs-sys-0.3.5
discard-1.0.4
either-1.6.1
env_logger-0.8.2
fnv-1.0.7
fuzzy-matcher-0.3.7
getrandom-0.1.15
hermit-abi-0.1.17
humantime-2.0.1
ident_case-1.0.1
itoa-0.4.6
lazy_static-1.4.0
libc-0.2.81
log-0.4.11
maybe-uninit-2.0.0
memchr-2.3.4
memoffset-0.6.1
nix-0.14.1
nix-0.19.1
num-integer-0.1.44
num-traits-0.2.14
num_cpus-1.13.0
once_cell-1.5.2
proc-macro-hack-0.5.19
proc-macro2-1.0.24
quote-1.0.7
rayon-1.5.0
rayon-core-1.9.0
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.4.2
regex-syntax-0.6.21
rust-argon2-0.8.3
rustc_version-0.2.3
ryu-1.0.5
scopeguard-1.1.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.118
serde_derive-1.0.118
serde_json-1.0.60
sha1-0.6.0
shlex-0.1.1
standback-0.2.13
stdweb-0.4.20
stdweb-derive-0.5.3
stdweb-internal-macros-0.2.9
stdweb-internal-runtime-0.1.5
strsim-0.10.0
strsim-0.8.0
syn-1.0.54
term-0.6.1
termcolor-1.1.2
textwrap-0.11.0
thread_local-1.0.1
time-0.1.44
time-0.2.23
time-macros-0.1.1
time-macros-impl-0.1.1
timer-0.2.0
tuikit-0.4.5
unicode-width-0.1.8
unicode-xid-0.2.1
utf8parse-0.2.0
vec_map-0.8.2
version_check-0.9.2
void-1.0.2
vte-0.9.0
vte_generate_state_changes-0.1.1
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.69
wasm-bindgen-backend-0.2.69
wasm-bindgen-macro-0.2.69
wasm-bindgen-macro-support-0.2.69
wasm-bindgen-shared-0.2.69
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
${P}
"

inherit cargo optfeature

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="
	https://crates.io/crates/skim
	https://github.com/lotabout/skim
"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="usr/bin/sk"

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	dobin bin/sk-tmux

	insinto /usr/share/vim/vimfiles/plugin
	doins "plugin/${PN}.vim"

	# install bash, zsh, fish completion and keybindings
	# since provided completions override a lot of commands,
	# install to /usr/share
	insinto "/usr/share/${PN}"
	doins shell/*.{ba,z,fi}sh
}

pkg_postinst() {
	optfeature 'support for sk-tmux script to run skim in a tmux pane' \
		app-misc/tmux
}
