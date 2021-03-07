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
assert_cmd-1.0.1
atty-0.2.14
autocfg-1.0.0
base64-0.11.0
base64-0.12.1
bincode-1.2.1
bit-set-0.5.1
bit-vec-0.5.1
bitflags-1.2.1
blake2b_simd-0.5.10
block-buffer-0.7.3
block-padding-0.1.5
bstr-0.2.12
byte-tools-0.3.1
byteorder-1.3.4
cc-1.0.52
cfg-if-0.1.10
chrono-0.4.11
clap-2.33.0
console-0.11.2
constant_time_eq-0.1.5
content_inspector-0.2.4
crc32fast-1.2.0
crossbeam-utils-0.7.2
difference-2.0.0
digest-0.8.1
dirs-2.0.2
dirs-sys-0.3.4
doc-comment-0.3.3
dtoa-0.4.5
either-1.5.3
encode_unicode-0.3.6
encoding-0.2.33
encoding-index-japanese-1.20141219.5
encoding-index-korean-1.20141219.5
encoding-index-simpchinese-1.20141219.5
encoding-index-singlebyte-1.20141219.5
encoding-index-tradchinese-1.20141219.5
encoding_index_tests-0.1.4
error-chain-0.12.2
fake-simd-0.1.2
fancy-regex-0.3.3
flate2-1.0.14
fnv-1.0.6
fuchsia-cprng-0.1.1
generic-array-0.12.3
getrandom-0.1.14
git2-0.13.5
glob-0.3.0
globset-0.4.5
hermit-abi-0.1.11
idna-0.1.5
idna-0.2.0
indexmap-1.3.2
itertools-0.8.2
itoa-0.4.5
jobserver-0.1.21
kernel32-sys-0.2.2
kstring-0.1.0
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.69
libgit2-sys-0.12.5+1.0.0
libz-sys-1.0.25
line-wrap-0.1.1
linked-hash-map-0.5.2
liquid-0.20.0
liquid-core-0.20.0
liquid-derive-0.20.0
liquid-lib-0.20.0
log-0.4.8
maplit-1.0.2
matches-0.1.8
memchr-2.3.3
miniz_oxide-0.3.6
num-integer-0.1.42
num-traits-0.2.11
once_cell-1.3.1
onig-6.0.0
onig_sys-69.5.0
opaque-debug-0.2.3
path_abs-0.5.0
percent-encoding-1.0.1
percent-encoding-2.1.0
pest-2.1.3
pest_derive-2.1.0
pest_generator-2.1.3
pest_meta-2.1.3
pkg-config-0.3.17
plist-1.0.0
predicates-1.0.4
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro-hack-0.5.15
proc-macro2-1.0.10
proc-quote-0.3.2
proc-quote-impl-0.3.2
quote-1.0.3
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.4
regex-1.3.7
regex-syntax-0.6.17
remove_dir_all-0.5.2
rust-argon2-0.7.0
ryu-1.0.3
safemem-0.3.3
same-file-1.0.6
semver-0.9.0
semver-parser-0.7.0
serde-1.0.110
serde_derive-1.0.110
serde_json-1.0.51
serde_yaml-0.8.12
sha-1-0.8.2
shell-words-1.0.0
smallvec-1.3.0
std_prelude-0.2.12
strsim-0.8.0
syn-1.0.17
syntect-4.2.0
tempdir-0.3.7
term_size-0.3.1
terminal_size-0.1.12
termios-0.3.2
textwrap-0.11.0
thread_local-1.0.1
time-0.1.43
treeline-0.1.0
typenum-1.12.0
ucd-trie-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.12
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.0
url-1.7.2
url-2.1.1
vcpkg-0.2.8
vec_map-0.8.1
version_check-0.9.1
wait-timeout-0.2.0
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
wild-2.0.3
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xml-rs-0.8.2
yaml-rust-0.4.3
"

inherit cargo

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-libs/libgit2-0.99:=
	dev-libs/oniguruma:=
	sys-libs/zlib:=
"

# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

BDEPEND="virtual/pkgconfig"

DOCS=( README.md doc/alternatives.md )

QA_FLAGS_IGNORED="/usr/bin/bat"

src_configure() {
	export RUSTONIG_SYSTEM_LIBONIG=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
}

src_install() {
	cargo_src_install

	einstalldocs

	doman target/release/build/bat-*/out/assets/manual/bat.1

	insinto /usr/share/fish/vendor_completions.d/
	doins target/release/build/bat-*/out/assets/completions/bat.fish
}
