# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.4
aho-corasick-0.7.10
ansi_colours-1.0.1
ansi_term-0.11.0
ansi_term-0.12.1
anymap-0.12.1
arrayref-0.3.6
arrayvec-0.5.1
assert_cmd-0.12.0
atty-0.2.14
autocfg-1.0.0
backtrace-0.3.45
backtrace-sys-0.1.34
base64-0.10.1
base64-0.11.0
bat-0.13.0
bincode-1.2.1
bindgen-0.50.1
bitflags-1.2.1
blake2b_simd-0.5.10
block-buffer-0.7.3
block-padding-0.1.5
bstr-0.2.12
byte-tools-0.3.1
byteorder-1.3.4
cc-1.0.50
cexpr-0.3.6
cfg-if-0.1.10
chrono-0.4.11
clang-sys-0.28.1
clap-2.33.0
clicolors-control-1.0.1
console-0.10.0
constant_time_eq-0.1.5
content_inspector-0.2.4
crc32fast-1.2.0
crossbeam-utils-0.7.2
deunicode-1.1.0
difference-2.0.0
digest-0.8.1
dirs-2.0.2
dirs-sys-0.3.4
doc-comment-0.3.3
either-1.5.3
encode_unicode-0.3.6
encoding-0.2.33
encoding-index-japanese-1.20141219.5
encoding-index-korean-1.20141219.5
encoding-index-simpchinese-1.20141219.5
encoding-index-singlebyte-1.20141219.5
encoding-index-tradchinese-1.20141219.5
encoding_index_tests-0.1.4
env_logger-0.6.2
error-chain-0.12.2
escargot-0.5.0
failure-0.1.7
fake-simd-0.1.2
flate2-1.0.14
fnv-1.0.6
fuchsia-cprng-0.1.1
fxhash-0.2.1
generic-array-0.12.3
getrandom-0.1.14
git2-0.13.0
glob-0.3.0
globset-0.4.5
hermit-abi-0.1.8
humantime-1.3.0
idna-0.1.5
idna-0.2.0
itertools-0.8.2
itoa-0.4.5
jobserver-0.1.21
kernel32-sys-0.2.2
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.68
libgit2-sys-0.12.0+0.99.0
libloading-0.5.2
libz-sys-1.0.25
line-wrap-0.1.1
linked-hash-map-0.5.2
liquid-0.19.0
liquid-compiler-0.19.0
liquid-derive-0.19.0
liquid-error-0.19.0
liquid-interpreter-0.19.0
liquid-value-0.19.1
log-0.4.8
maplit-1.0.2
matches-0.1.8
memchr-2.3.3
miniz_oxide-0.3.6
nom-4.2.3
num-integer-0.1.42
num-traits-0.2.11
onig-5.0.0
onig_sys-69.2.0
opaque-debug-0.2.3
peeking_take_while-0.1.2
percent-encoding-1.0.1
percent-encoding-2.1.0
pest-2.1.3
pest_derive-2.1.0
pest_generator-2.1.3
pest_meta-2.1.3
pkg-config-0.3.17
plist-0.4.2
predicates-1.0.4
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro-hack-0.5.14
proc-macro2-0.4.30
proc-macro2-1.0.9
proc-quote-0.2.2
proc-quote-impl-0.2.2
quick-error-1.2.3
quote-0.6.13
quote-1.0.3
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.4
regex-1.3.5
regex-syntax-0.6.17
remove_dir_all-0.5.2
rust-argon2-0.7.0
rustc-demangle-0.1.16
ryu-1.0.3
safemem-0.3.3
same-file-1.0.6
serde-1.0.105
serde_derive-1.0.105
serde_json-1.0.48
sha-1-0.8.2
shell-words-0.1.0
shlex-0.1.1
smallvec-1.2.0
strsim-0.8.0
syn-0.15.44
syn-1.0.17
syntect-3.3.0
tempdir-0.3.7
term_size-0.3.1
termcolor-1.1.0
termios-0.3.1
textwrap-0.11.0
thread_local-1.0.1
time-0.1.42
treeline-0.1.0
typenum-1.11.2
ucd-trie-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.12
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.1.0
unicode-xid-0.2.0
url-1.7.2
url-2.1.1
vcpkg-0.2.8
vec_map-0.8.1
version_check-0.1.5
version_check-0.9.1
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
which-2.0.1
wild-2.0.2
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.3
winapi-x86_64-pc-windows-gnu-0.4.0
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

DEPEND="sys-libs/zlib"

# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

BDEPEND="sys-devel/clang"

DOCS=( README.md doc/alternatives.md )

QA_FLAGS_IGNORED="/usr/bin/bat"

src_install() {
	cargo_src_install
	doman target/release/build/bat-*/out/assets/manual/bat.1
	einstalldocs
	insinto /usr/share/fish/vendor_completions.d/
	doins target/release/build/bat-*/out/assets/completions/bat.fish
}
