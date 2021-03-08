# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler-0.2.3
aho-corasick-0.7.15
ansi_colours-1.0.1
ansi_term-0.11.0
ansi_term-0.12.1
arrayvec-0.5.2
atty-0.2.14
autocfg-1.0.1
base64-0.13.0
bincode-1.3.1
bitflags-1.2.1
box_drawing-0.1.2
bytelines-2.2.2
byteorder-1.3.4
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
console-0.14.0
crc32fast-1.2.1
dirs-next-2.0.0
dirs-sys-next-0.1.1
either-1.6.1
encode_unicode-0.3.6
error-chain-0.12.4
flate2-1.0.19
fnv-1.0.7
form_urlencoded-1.0.0
getrandom-0.1.16
git2-0.13.17
hashbrown-0.8.2
heck-0.3.2
hermit-abi-0.1.17
idna-0.2.0
indexmap-1.5.2
itertools-0.10.0
itoa-0.4.7
jobserver-0.1.21
lazycell-1.3.0
lazy_static-1.4.0
libc-0.2.81
libgit2-sys-0.12.18+1.1.0
libz-sys-1.1.2
line-wrap-0.1.1
linked-hash-map-0.5.3
log-0.4.11
matches-0.1.8
memchr-2.3.4
miniz_oxide-0.4.3
num-integer-0.1.44
num-traits-0.2.14
onig-6.1.1
onig_sys-69.6.0
percent-encoding-2.1.0
pkg-config-0.3.19
plist-1.0.1
proc-macro2-1.0.24
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
quote-1.0.8
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.4.3
regex-syntax-0.6.22
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
serde-1.0.118
serde_derive-1.0.118
serde_json-1.0.61
shell-words-1.0.0
strsim-0.8.0
structopt-0.3.21
structopt-derive-0.4.14
syn-1.0.57
syntect-4.5.0
terminal_size-0.1.15
textwrap-0.11.0
thread_local-1.0.1
tinyvec-1.1.0
tinyvec_macros-0.1.0
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
url-2.2.0
utf8parse-0.2.0
vcpkg-0.2.11
vec_map-0.8.2
version_check-0.9.2
vte-0.10.0
vte_generate_state_changes-0.1.1
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xml-rs-0.8.3
yaml-rust-0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="A syntax-highlighting pager for git"
HOMEPAGE="https://github.com/dandavison/delta"
SRC_URI="https://github.com/dandavison/delta/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"
S="${WORKDIR}/${P/git-/}"

LICENSE="Apache-2.0 BSD-2 Boost-1.0 CC0-1.0 ISC LGPL-3+ MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64"

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
