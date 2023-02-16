# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
adler-1.0.2
ahash-0.4.7
ahash-0.7.6
aho-corasick-0.7.20
android_system_properties-0.1.5
ansi_colours-1.2.1
anyhow-1.0.68
argh-0.1.9
argh_derive-0.1.9
argh_shared-0.1.9
atty-0.2.14
autocfg-1.1.0
base64-0.13.1
bet-1.0.2
bincode-1.3.3
bit_field-0.10.1
bitflags-1.3.2
bstr-0.2.17
bumpalo-3.11.1
bytemuck-1.12.3
byteorder-1.4.3
cc-1.0.78
cfg-if-1.0.0
char_reader-0.1.1
chrono-0.4.23
clap-3.2.23
clap_complete-3.2.5
clap_derive-3.2.18
clap_lex-0.2.4
cli-log-2.0.0
clipboard-win-4.4.2
codespan-reporting-0.11.1
color_quant-1.1.0
coolor-0.5.0
core-foundation-sys-0.8.3
crc32fast-1.3.2
crokey-0.4.3
crokey-proc_macros-0.4.0
crossbeam-0.8.2
crossbeam-channel-0.5.6
crossbeam-deque-0.8.2
crossbeam-epoch-0.9.13
crossbeam-queue-0.3.8
crossbeam-utils-0.8.14
crossterm-0.23.2
crossterm_winapi-0.9.0
crunchy-0.2.2
csv-1.1.6
csv-core-0.1.10
csv2svg-0.1.8
custom_error-1.9.2
cxx-1.0.85
cxx-build-1.0.85
cxxbridge-flags-1.0.85
cxxbridge-macro-1.0.85
deser-hjson-1.1.0
directories-4.0.1
directories-next-2.0.0
dirs-sys-0.3.7
dirs-sys-next-0.1.2
doc-comment-0.3.3
either-1.8.0
error-code-2.3.1
exr-1.5.2
fallible-iterator-0.2.0
fallible-streaming-iterator-0.1.9
fastrand-1.8.0
file-size-1.0.3
flate2-1.0.25
flume-0.10.14
fnv-1.0.7
form_urlencoded-1.1.0
futures-core-0.3.25
futures-sink-0.3.25
getrandom-0.2.8
gif-0.11.4
git2-0.14.4
glassbench-0.3.4
glob-0.3.0
half-2.2.0
hashbrown-0.12.3
hashbrown-0.9.1
hashlink-0.6.0
heck-0.4.0
hermit-abi-0.1.19
hermit-abi-0.2.6
iana-time-zone-0.1.53
iana-time-zone-haiku-0.1.1
id-arena-2.2.1
idna-0.3.0
image-0.24.5
include_dir-0.7.3
include_dir_macros-0.7.3
indexmap-1.9.2
instant-0.1.12
is_executable-1.0.1
itoa-0.4.8
itoa-1.0.5
jobserver-0.1.25
jpeg-decoder-0.3.0
js-sys-0.3.60
lazy-regex-2.3.2
lazy-regex-proc_macros-2.3.2
lazy_static-1.4.0
lebe-0.5.2
lfs-core-0.11.1
libc-0.2.139
libgit2-sys-0.13.4+1.4.2
libsqlite3-sys-0.20.1
libz-sys-1.1.8
line-wrap-0.1.1
link-cplusplus-1.0.8
linked-hash-map-0.5.6
lock_api-0.4.9
log-0.4.17
memchr-2.5.0
memmap2-0.5.8
memoffset-0.6.5
memoffset-0.7.1
minimad-0.9.1
miniz_oxide-0.6.2
mio-0.8.5
nanorand-0.7.0
nix-0.22.3
num-integer-0.1.45
num-rational-0.4.1
num-traits-0.2.15
num_cpus-1.15.0
once_cell-1.17.0
onig-6.4.0
onig_sys-69.8.1
open-1.7.1
opener-0.5.0
os_str_bytes-6.4.1
parking_lot-0.12.1
parking_lot_core-0.9.5
pathdiff-0.2.1
percent-encoding-2.2.0
phf-0.10.1
phf_generator-0.10.0
phf_macros-0.10.0
phf_shared-0.10.0
pin-project-1.0.12
pin-project-internal-1.0.12
pkg-config-0.3.26
plist-1.3.1
png-0.17.7
ppv-lite86-0.2.17
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
proc-macro2-1.0.49
proc-status-0.1.1
quick-xml-0.22.0
quote-1.0.23
rand-0.8.5
rand_chacha-0.3.1
rand_core-0.6.4
rayon-1.6.1
rayon-core-1.10.1
redox_syscall-0.2.16
redox_users-0.4.3
regex-1.7.0
regex-automata-0.1.10
regex-syntax-0.6.28
remove_dir_all-0.5.3
rgb-0.8.34
rusqlite-0.24.2
ryu-1.0.12
safemem-0.3.3
same-file-1.0.6
scoped_threadpool-0.1.9
scopeguard-1.1.0
scratch-1.0.3
secular-1.0.1
serde-1.0.152
serde_derive-1.0.152
serde_json-1.0.91
signal-hook-0.3.14
signal-hook-mio-0.2.3
signal-hook-registry-1.4.0
siphasher-0.3.10
smallvec-1.10.0
snafu-0.7.4
snafu-derive-0.7.4
spin-0.9.4
splitty-1.0.1
str-buf-1.0.6
strict-0.1.4
strsim-0.10.0
svg-0.8.2
svg-0.10.0
syn-1.0.107
syntect-no-panic-4.6.1
tempfile-3.3.0
termcolor-1.1.3
termimad-0.20.6
terminal-clipboard-0.3.1
terminal-light-1.0.1
termux-clipboard-0.1.0
textwrap-0.16.0
thiserror-1.0.38
thiserror-impl-1.0.38
threadpool-1.8.1
tiff-0.8.1
time-0.1.45
time-0.3.17
time-core-0.1.0
time-macros-0.2.6
tinyvec-1.6.0
tinyvec_macros-0.1.0
toml-0.5.10
umask-2.0.0
unicode-bidi-0.3.8
unicode-ident-1.0.6
unicode-normalization-0.1.22
unicode-width-0.1.10
url-2.3.1
users-0.11.0
vcpkg-0.2.15
version_check-0.9.4
walkdir-2.3.2
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.83
wasm-bindgen-backend-0.2.83
wasm-bindgen-macro-0.2.83
wasm-bindgen-macro-support-0.2.83
wasm-bindgen-shared-0.2.83
weezl-0.1.7
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.42.0
windows_aarch64_gnullvm-0.42.0
windows_aarch64_msvc-0.42.0
windows_i686_gnu-0.42.0
windows_i686_msvc-0.42.0
windows_x86_64_gnu-0.42.0
windows_x86_64_gnullvm-0.42.0
windows_x86_64_msvc-0.42.0
x11-clipboard-0.5.3
xcb-0.10.1
xml-rs-0.8.4
xterm-query-0.1.0
xterm-query-0.2.0
yaml-rust-0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="A new way to see and navigate directory trees"
HOMEPAGE="https://dystroy.org/broot/ https://github.com/Canop/broot"
SRC_URI="https://github.com/Canop/broot/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="Apache-2.0 BSD-2 BSD LGPL-3+ MIT ZLIB"
SLOT="0"
KEYWORDS="amd64"
IUSE="X"

RDEPEND="
	dev-libs/libgit2:=
	sys-libs/zlib
	X? ( x11-libs/libxcb:= )
"
DEPEND="${RDEPEND}"
BDEPEND=">=virtual/rust-1.65"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_configure() {
	export RUSTFLAGS="-Cstrip=none ${RUSTFLAGS}" #835400
	local myfeatures=( $(usev X clipboard) )

	cargo_src_configure --no-default-features
}

src_prepare() {
	default

	local mandate=$(date -r man/page +'%Y/%m/%d' || die)
	sed -e "s|#version|${PV}|" \
		-e "s|#date|${mandate}|" \
		man/page > "${T}"/${PN}.1 || die
}

src_install() {
	cargo_src_install

	doman "${T}"/${PN}.1

	local build_dir=( target/$(usex debug{,} release)/build/${PN}-*/out )
	cd ${build_dir[0]} || die

	newbashcomp ${PN}.bash ${PN}
	newbashcomp br.bash br

	insinto /usr/share/zsh/site-functions
	doins _${PN}
	doins _br

	insinto /usr/share/fish/vendor_completions.d
	doins ${PN}.fish
	doins br.fish
}
