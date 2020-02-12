# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.3
aho-corasick-0.7.6
ansi_colours-1.0.1
ansi_term-0.11.0
ansi_term-0.12.1
arrayref-0.3.5
arrayvec-0.4.11
assert_cmd-0.11.1
atty-0.2.13
autocfg-0.1.6
backtrace-0.3.35
backtrace-sys-0.1.31
base64-0.10.1
bat-0.12.1
bincode-1.1.4
bindgen-0.50.0
bitflags-1.1.0
blake2b_simd-0.5.7
byteorder-1.3.2
cc-1.0.41
cexpr-0.3.5
cfg-if-0.1.9
clang-sys-0.28.1
clap-2.33.0
clicolors-control-1.0.1
cloudabi-0.0.3
console-0.8.0
constant_time_eq-0.1.4
content_inspector-0.2.4
crc32fast-1.2.0
crossbeam-utils-0.6.6
difference-2.0.0
dirs-2.0.2
dirs-sys-0.3.4
encode_unicode-0.3.6
encoding-0.2.33
encoding-index-japanese-1.20141219.5
encoding-index-korean-1.20141219.5
encoding-index-simpchinese-1.20141219.5
encoding-index-singlebyte-1.20141219.5
encoding-index-tradchinese-1.20141219.5
encoding_index_tests-0.1.4
env_logger-0.6.2
error-chain-0.12.1
escargot-0.4.0
escargot-0.5.0
failure-0.1.5
failure_derive-0.1.5
flate2-1.0.11
fnv-1.0.6
fuchsia-cprng-0.1.1
fxhash-0.2.1
git2-0.10.0
glob-0.3.0
humantime-1.2.0
idna-0.2.0
itoa-0.4.4
kernel32-sys-0.2.2
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.62
libgit2-sys-0.9.0
libloading-0.5.2
libz-sys-1.0.25
line-wrap-0.1.1
linked-hash-map-0.5.2
log-0.4.8
matches-0.1.8
memchr-2.2.1
miniz-sys-0.1.12
miniz_oxide-0.3.2
nodrop-0.1.13
nom-4.2.3
onig-5.0.0
onig_sys-69.2.0
peeking_take_while-0.1.2
percent-encoding-2.1.0
pkg-config-0.3.15
plist-0.4.2
predicates-1.0.1
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro2-0.4.30
proc-macro2-1.0.2
quick-error-1.2.2
quote-0.6.13
quote-1.0.2
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rand_os-0.1.3
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.1
regex-1.2.1
regex-syntax-0.6.11
remove_dir_all-0.5.2
rust-argon2-0.5.1
rustc-demangle-0.1.16
ryu-1.0.0
safemem-0.3.2
same-file-1.0.5
serde-1.0.99
serde_derive-1.0.99
serde_json-1.0.40
shell-words-0.1.0
shlex-0.1.1
smallvec-0.6.10
strsim-0.8.0
syn-0.15.44
syn-1.0.5
synstructure-0.10.2
syntect-3.2.1
tempdir-0.3.7
term_size-0.3.1
termcolor-1.0.5
termios-0.3.1
textwrap-0.11.0
thread_local-0.3.6
treeline-0.1.0
unicode-bidi-0.3.4
unicode-normalization-0.1.8
unicode-width-0.1.6
unicode-xid-0.1.0
unicode-xid-0.2.0
url-2.1.0
vcpkg-0.2.7
vec_map-0.8.1
version_check-0.1.5
walkdir-2.2.9
which-2.0.1
wild-2.0.2
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.2
xml-rs-0.8.0
yaml-rust-0.4.3
"

inherit cargo

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

# >app-backup/bacula-9.2[qt5] has file collisions, #686118
DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]"
BDEPEND=">=virtual/rust-1.31.0"

DOCS=( README.md doc/alternatives.md )

QA_FLAGS_IGNORED="/usr/bin/bat"

src_install() {
	cargo_src_install
	doman doc/bat.1
	einstalldocs
	insinto /usr/share/fish/vendor_completions.d/
	doins assets/completions/bat.fish
}
