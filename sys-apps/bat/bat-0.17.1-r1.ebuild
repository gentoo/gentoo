# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler-0.2.3
aho-corasick-0.7.13
ansi_colours-1.0.1
ansi_term-0.11.0
ansi_term-0.12.1
arrayref-0.3.6
arrayvec-0.5.1
assert_cmd-1.0.1
atty-0.2.14
autocfg-1.0.1
base64-0.12.3
bincode-1.3.1
bitflags-1.2.1
bit-set-0.5.2
bit-vec-0.6.2
blake2b_simd-0.5.10
block-buffer-0.7.3
block-padding-0.1.5
bstr-0.2.13
byteorder-1.3.4
byte-tools-0.3.1
cc-1.0.60
cfg-if-0.1.10
chrono-0.4.19
clap-2.33.3
clircle-0.1.3
console-0.13.0
constant_time_eq-0.1.5
content_inspector-0.2.4
crc32fast-1.2.0
crossbeam-utils-0.7.2
difference-2.0.0
digest-0.8.1
dirs-3.0.1
dirs-sys-0.3.5
doc-comment-0.3.3
dtoa-0.4.6
encode_unicode-0.3.6
encoding-0.2.33
encoding-index-japanese-1.20141219.5
encoding-index-korean-1.20141219.5
encoding-index-simpchinese-1.20141219.5
encoding-index-singlebyte-1.20141219.5
encoding_index_tests-0.1.4
encoding-index-tradchinese-1.20141219.5
error-chain-0.12.4
fake-simd-0.1.2
fancy-regex-0.3.5
flate2-1.0.18
float-cmp-0.8.0
fnv-1.0.7
fuchsia-cprng-0.1.1
generic-array-0.12.3
getrandom-0.1.15
git2-0.13.12
glob-0.3.0
globset-0.4.6
hashbrown-0.9.1
hermit-abi-0.1.16
idna-0.2.0
indexmap-1.6.0
itoa-0.4.6
jobserver-0.1.21
lazycell-1.3.0
lazy_static-1.4.0
libc-0.2.78
libgit2-sys-0.12.14+1.1.0
libz-sys-1.1.2
line-wrap-0.1.1
linked-hash-map-0.5.3
log-0.4.11
maplit-1.0.2
matches-0.1.8
memchr-2.3.3
miniz_oxide-0.4.2
nix-0.19.0
normalize-line-endings-0.3.0
num-integer-0.1.43
num-traits-0.2.12
onig-6.1.0
onig_sys-69.5.1
opaque-debug-0.2.3
path_abs-0.5.0
percent-encoding-2.1.0
pest-2.1.3
pest_derive-2.1.0
pest_generator-2.1.3
pest_meta-2.1.3
pkg-config-0.3.18
plist-1.0.0
predicates-1.0.5
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro2-1.0.24
quote-1.0.7
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rdrand-0.4.0
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.3.9
regex-syntax-0.6.18
remove_dir_all-0.5.3
rust-argon2-0.8.2
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
semver-0.11.0
semver-parser-0.10.0
serde-1.0.117
serde_derive-1.0.117
serde_json-1.0.58
serde_yaml-0.8.14
sha-1-0.8.2
shell-words-1.0.0
std_prelude-0.2.12
strsim-0.8.0
syn-1.0.42
syntect-4.4.0
tempdir-0.3.7
terminal_size-0.1.13
term_size-0.3.2
textwrap-0.11.0
thread_local-1.0.1
tinyvec-0.3.4
treeline-0.1.0
typenum-1.12.0
ucd-trie-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.13
unicode-width-0.1.8
unicode-xid-0.2.1
url-2.1.1
vcpkg-0.2.10
vec_map-0.8.2
version_check-0.9.2
wait-timeout-0.2.0
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
wild-2.0.4
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xml-rs-0.8.3
yaml-rust-0.4.4
"

inherit cargo

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.1.0:=[threads]
	dev-libs/oniguruma:=
	sys-libs/zlib
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

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

	insinto /usr/share/zsh/site-functions/
	newins target/release/build/bat-*/out/assets/completions/bat.zsh _${PN}
}
