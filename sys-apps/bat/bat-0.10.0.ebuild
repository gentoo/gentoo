# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.3
aho-corasick-0.6.9
ansi_colours-1.0.1
ansi_term-0.11.0
argon2rs-0.2.5
arrayvec-0.4.10
assert_cmd-0.11.0
atty-0.2.11
backtrace-0.3.11
backtrace-sys-0.1.28
base64-0.9.3
bincode-1.0.1
bitflags-1.0.4
blake2-rfc-0.2.18
build_const-0.2.1
byteorder-1.2.7
cc-1.0.25
cfg-if-0.1.6
clap-2.32.0
clicolors-control-1.0.0
cloudabi-0.0.3
console-0.7.5
constant_time_eq-0.1.3
content_inspector-0.2.4
crc-1.8.1
difference-2.0.0
dirs-1.0.4
encode_unicode-0.3.5
encoding-0.2.33
encoding-index-japanese-1.20141219.5
encoding-index-korean-1.20141219.5
encoding-index-simpchinese-1.20141219.5
encoding-index-singlebyte-1.20141219.5
encoding-index-tradchinese-1.20141219.5
encoding_index_tests-0.1.4
error-chain-0.12.0
escargot-0.4.0
failure-0.1.5
failure_derive-0.1.5
flate2-1.0.4
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
git2-0.8.0
glob-0.2.11
humantime-1.1.1
idna-0.1.5
itoa-0.4.3
kernel32-sys-0.2.2
lazy_static-1.2.0
lazycell-1.2.0
libc-0.2.43
libgit2-sys-0.7.11
libz-sys-1.0.25
linked-hash-map-0.5.1
lock_api-0.1.4
log-0.4.6
matches-0.1.8
memchr-2.1.1
miniz-sys-0.1.11
miniz_oxide-0.2.0
miniz_oxide_c_api-0.2.0
nodrop-0.1.13
onig-4.2.1
onig_sys-69.0.0
owning_ref-0.3.3
parking_lot-0.6.4
parking_lot_core-0.3.1
percent-encoding-1.0.1
pkg-config-0.3.14
plist-0.3.0
predicates-1.0.0
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro2-0.4.21
quick-error-1.2.2
quote-0.6.10
rand-0.4.3
rand-0.5.5
rand_core-0.2.2
rand_core-0.3.0
redox_syscall-0.1.40
redox_termios-0.1.1
redox_users-0.2.0
regex-1.0.6
regex-syntax-0.6.3
remove_dir_all-0.5.1
rustc-demangle-0.1.13
rustc_version-0.2.3
ryu-0.2.7
safemem-0.3.0
same-file-1.0.4
scoped_threadpool-0.1.9
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.80
serde_derive-1.0.80
serde_json-1.0.33
shell-words-0.1.0
smallvec-0.6.5
stable_deref_trait-1.1.1
strsim-0.7.0
syn-0.15.19
synstructure-0.10.1
syntect-3.0.2
tempdir-0.3.7
term_size-0.3.1
termion-1.5.1
termios-0.3.1
textwrap-0.10.0
thread_local-0.3.6
treeline-0.1.0
ucd-util-0.1.2
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.1.0
unreachable-1.0.0
url-1.7.2
utf8-ranges-1.0.2
vcpkg-0.2.6
vec_map-0.8.1
version_check-0.1.5
void-1.0.2
walkdir-2.2.6
wild-2.0.1
winapi-0.2.8
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
xml-rs-0.7.0
yaml-rust-0.4.2
"

inherit cargo

DESCRIPTION="A cat(1) clone with wings"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=">=virtual/rust-1.30.0"

QA_FLAGS_IGNORED="/usr/bin/bat"

src_install() {
	cargo_src_install --path=.
	einstalldocs
}
