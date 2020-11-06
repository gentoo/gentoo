# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler32-1.0.4
aho-corasick-0.7.6
ansi_colours-1.0.1
ansi_term-0.11.0
ansi_term-0.12.1
arrayref-0.3.5
arrayvec-0.5.1
atty-0.2.14
autocfg-1.0.0
backtrace-0.3.40
backtrace-sys-0.1.32
base64-0.10.1
base64-0.12.1
bincode-1.2.1
bitflags-1.2.1
blake2b_simd-0.5.9
box_drawing-0.1.2
bytelines-2.2.2
byteorder-1.3.2
cc-1.0.54
cfg-if-0.1.9
chrono-0.4.11
clap-2.33.0
cloudabi-0.0.3
console-0.12.0
constant_time_eq-0.1.4
crc32fast-1.2.0
crossbeam-utils-0.6.6
dirs-3.0.1
dirs-sys-0.3.5
either-1.5.3
encode_unicode-0.3.5
error-chain-0.12.4
failure-0.1.6
failure_derive-0.1.6
flate2-1.0.12
fnv-1.0.6
fuchsia-cprng-0.1.1
git2-0.13.11
heck-0.3.1
hermit-abi-0.1.12
idna-0.2.0
indexmap-1.3.2
itertools-0.9.0
itoa-0.4.4
jobserver-0.1.21
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.60
libgit2-sys-0.12.13+1.0.1
libz-sys-1.1.0
line-wrap-0.1.1
linked-hash-map-0.5.2
log-0.4.8
matches-0.1.8
memchr-2.2.1
miniz_oxide-0.3.6
num-integer-0.1.42
num-traits-0.2.11
onig-6.0.0
onig_sys-69.5.0
percent-encoding-2.1.0
pkg-config-0.3.17
plist-1.0.0
proc-macro-error-1.0.2
proc-macro-error-attr-1.0.2
proc-macro2-0.4.30
proc-macro2-1.0.6
quote-0.6.13
quote-1.0.2
rand_core-0.3.1
rand_core-0.4.2
rand_os-0.1.3
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.1
regex-1.3.9
regex-syntax-0.6.18
rust-argon2-0.5.1
rustc-demangle-0.1.16
ryu-1.0.0
safemem-0.3.1
same-file-1.0.5
serde-1.0.98
serde_derive-1.0.98
serde_json-1.0.40
shell-words-1.0.0
smallvec-1.4.0
strsim-0.8.0
structopt-0.3.19
structopt-derive-0.4.12
syn-0.15.43
syn-1.0.11
syn-mid-0.5.0
synstructure-0.12.3
syntect-4.4.0
terminal_size-0.1.13
termios-0.3.1
textwrap-0.11.0
thread_local-1.0.1
unicode-bidi-0.3.4
unicode-normalization-0.1.12
unicode-segmentation-1.6.0
unicode-width-0.1.8
unicode-xid-0.1.0
unicode-xid-0.2.0
url-2.1.1
utf8parse-0.2.0
vcpkg-0.2.9
vec_map-0.8.1
version_check-0.9.1
vte-0.8.0
vte_generate_state_changes-0.1.1
walkdir-2.2.9
winapi-0.3.7
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.4
winapi-x86_64-pc-windows-gnu-0.4.0
xml-rs-0.8.0
yaml-rust-0.4.3
"

inherit bash-completion-r1 cargo

DESCRIPTION="A syntax-highlighting pager for git"
HOMEPAGE="https://github.com/dandavison/delta"
SRC_URI="https://github.com/dandavison/delta/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"
S="${WORKDIR}/${P/git-/}"

LICENSE="Apache-2.0 BSD-2 Boost-1.0 CC0-1.0 ISC LGPL-3+ MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/libgit2:=
	dev-libs/oniguruma:=
"
RDEPEND="${DEPEND}
	!app-text/delta
"

QA_FLAGS_IGNORED="/usr/bin/delta"

src_configure() {
	# Some crates will auto-build and statically link C libraries(!)
	# Tracker bug #709568
	export RUSTONIG_SYSTEM_LIBONIG=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
}

src_install() {
	cargo_src_install

	# No man page (yet?)

	# Completions
	newbashcomp "${S}/etc/completion/completion.bash" delta

	insinto /usr/share/zsh/site-functions
	newins "${S}/etc/completion/completion.zsh" _delta
}
