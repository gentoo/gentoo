# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
adler@1.0.2
ahash@0.4.8
aho-corasick@1.1.3
android-tzdata@0.1.1
android_system_properties@0.1.5
ansi_colours@1.2.2
anstream@0.6.14
anstyle@1.0.7
anstyle-parse@0.2.4
anstyle-query@1.1.0
anstyle-wincon@3.0.3
anyhow@1.0.86
argh@0.1.12
argh_derive@0.1.12
argh_shared@0.1.12
arrayref@0.3.7
arrayvec@0.7.4
autocfg@1.3.0
base64@0.13.1
base64@0.21.7
base64@0.22.1
bet@1.0.3
bincode@1.3.3
bit_field@0.10.2
bitflags@1.3.2
bitflags@2.6.0
block@0.1.6
bstr@1.9.1
bumpalo@3.16.0
bytemuck@1.16.1
byteorder@1.5.0
cc@1.0.104
cfg-if@1.0.0
cfg_aliases@0.1.1
char_reader@0.1.1
chrono@0.4.38
clap@4.5.8
clap-help@1.2.0
clap_builder@4.5.8
clap_complete@4.5.7
clap_derive@4.5.8
clap_lex@0.7.1
clap_mangen@0.2.22
cli-log@2.0.0
clipboard-win@4.5.0
clipboard_macos@0.1.0
color_quant@1.1.0
colorchoice@1.0.1
coolor@0.9.0
core-foundation-sys@0.8.6
crc32fast@1.4.2
crokey@1.0.1
crokey-proc_macros@1.0.1
crossbeam@0.8.4
crossbeam-channel@0.5.13
crossbeam-deque@0.8.5
crossbeam-epoch@0.9.18
crossbeam-queue@0.3.11
crossbeam-utils@0.8.20
crossterm@0.27.0
crossterm_winapi@0.9.1
crunchy@0.2.2
csv@1.3.0
csv-core@0.1.11
csv2svg@0.2.2
custom_error@1.9.2
data-url@0.3.1
deranged@0.3.11
deser-hjson@2.2.4
directories@4.0.1
directories@5.0.1
dirs-sys@0.3.7
dirs-sys@0.4.1
doc-comment@0.3.3
either@1.13.0
equivalent@1.0.1
errno@0.3.9
error-code@2.3.1
exr@1.72.0
fallible-iterator@0.2.0
fallible-streaming-iterator@0.1.9
fastrand@2.1.0
fdeflate@0.3.4
file-size@1.0.3
flate2@1.0.30
float-cmp@0.9.0
flume@0.11.0
fnv@1.0.7
fontconfig-parser@0.5.6
fontdb@0.15.0
form_urlencoded@1.2.1
gethostname@0.3.0
getrandom@0.2.15
gif@0.12.0
gif@0.13.1
git2@0.14.4
glassbench@0.4.1
glob@0.3.1
half@2.4.1
hashbrown@0.9.1
hashbrown@0.14.5
hashlink@0.6.0
heck@0.4.1
heck@0.5.0
home@0.5.9
iana-time-zone@0.1.60
iana-time-zone-haiku@0.1.2
id-arena@2.2.1
idna@0.5.0
image@0.24.9
imagesize@0.12.0
include_dir@0.7.4
include_dir_macros@0.7.4
indexmap@2.2.6
is_executable@1.0.1
is_terminal_polyfill@1.70.0
itoa@1.0.11
jobserver@0.1.31
jpeg-decoder@0.3.1
js-sys@0.3.69
kurbo@0.9.5
lazy-regex@3.1.0
lazy-regex-proc_macros@3.1.0
lazy_static@1.5.0
lebe@0.5.2
lfs-core@0.11.2
libc@0.2.155
libgit2-sys@0.13.5+1.4.5
libredox@0.1.3
libsqlite3-sys@0.20.1
libz-sys@1.1.18
linked-hash-map@0.5.6
linux-raw-sys@0.4.14
lock_api@0.4.12
log@0.4.22
malloc_buf@0.0.6
memchr@2.7.4
memmap2@0.8.0
memmap2@0.9.4
memoffset@0.6.5
memoffset@0.7.1
minimad@0.13.1
miniz_oxide@0.7.4
mio@0.8.11
nix@0.22.3
nix@0.26.4
nix@0.28.0
normpath@1.2.0
num-conv@0.1.0
num-traits@0.2.19
objc@0.2.7
objc-foundation@0.1.1
objc_id@0.1.1
once_cell@1.19.0
onig@6.4.0
onig_sys@69.8.1
open@1.7.1
opener@0.6.1
option-ext@0.2.0
parking_lot@0.12.3
parking_lot_core@0.9.10
pathdiff@0.2.1
percent-encoding@2.3.1
phf@0.11.2
phf_generator@0.11.2
phf_macros@0.11.2
phf_shared@0.11.2
pico-args@0.5.0
pkg-config@0.3.30
plist@1.7.0
png@0.17.13
powerfmt@0.2.0
proc-macro2@1.0.86
proc-status@0.1.1
qoi@0.4.1
quick-xml@0.32.0
quote@1.0.36
rand@0.8.5
rand_core@0.6.4
rayon@1.10.0
rayon-core@1.12.1
rctree@0.5.0
redox_syscall@0.5.2
redox_users@0.4.5
regex@1.10.5
regex-automata@0.4.7
regex-syntax@0.6.29
regex-syntax@0.8.4
resvg@0.36.0
rgb@0.8.40
roff@0.2.1
roxmltree@0.18.1
roxmltree@0.19.0
rusqlite@0.24.2
rustc-hash@1.1.0
rustix@0.38.34
rustybuzz@0.10.0
ryu@1.0.18
same-file@1.0.6
scopeguard@1.2.0
secular@1.0.1
serde@1.0.203
serde_derive@1.0.203
serde_json@1.0.120
serde_spanned@0.6.6
signal-hook@0.3.17
signal-hook-mio@0.2.3
signal-hook-registry@1.4.2
simd-adler32@0.3.7
simplecss@0.2.1
siphasher@0.3.11
slotmap@1.0.7
smallvec@1.13.2
snafu@0.7.5
snafu-derive@0.7.5
spin@0.9.8
splitty@1.0.1
str-buf@1.0.6
strict@0.1.4
strict@0.2.0
strict-num@0.1.1
strsim@0.11.1
svg@0.16.0
svgtypes@0.12.0
syn@1.0.109
syn@2.0.68
syntect-no-panic@4.6.1
tempfile@3.10.1
termimad@0.29.4
terminal-clipboard@0.4.1
terminal-light@1.4.0
termux-clipboard@0.1.0
thiserror@1.0.61
thiserror-impl@1.0.61
tiff@0.9.1
time@0.3.36
time-core@0.1.2
time-macros@0.2.18
tiny-skia@0.11.4
tiny-skia-path@0.11.4
tinyvec@1.6.1
tinyvec_macros@0.1.1
toml@0.8.14
toml_datetime@0.6.6
toml_edit@0.22.14
trash@3.3.1
ttf-parser@0.19.2
umask@2.1.0
unicode-bidi@0.3.15
unicode-bidi-mirroring@0.1.0
unicode-ccc@0.1.2
unicode-ident@1.0.12
unicode-normalization@0.1.23
unicode-properties@0.1.1
unicode-script@0.5.6
unicode-vo@0.1.0
unicode-width@0.1.13
url@2.5.2
usvg@0.36.0
usvg-parser@0.36.0
usvg-text-layout@0.36.0
usvg-tree@0.36.0
utf8parse@0.2.2
uzers@0.11.3
vcpkg@0.2.15
version_check@0.9.4
walkdir@2.5.0
wasi@0.11.0+wasi-snapshot-preview1
wasm-bindgen@0.2.92
wasm-bindgen-backend@0.2.92
wasm-bindgen-macro@0.2.92
wasm-bindgen-macro-support@0.2.92
wasm-bindgen-shared@0.2.92
weezl@0.1.8
which@4.4.2
winapi@0.3.9
winapi-i686-pc-windows-gnu@0.4.0
winapi-util@0.1.8
winapi-wsapoll@0.1.2
winapi-x86_64-pc-windows-gnu@0.4.0
windows@0.44.0
windows-core@0.52.0
windows-sys@0.48.0
windows-sys@0.52.0
windows-targets@0.42.2
windows-targets@0.48.5
windows-targets@0.52.6
windows_aarch64_gnullvm@0.42.2
windows_aarch64_gnullvm@0.48.5
windows_aarch64_gnullvm@0.52.6
windows_aarch64_msvc@0.42.2
windows_aarch64_msvc@0.48.5
windows_aarch64_msvc@0.52.6
windows_i686_gnu@0.42.2
windows_i686_gnu@0.48.5
windows_i686_gnu@0.52.6
windows_i686_gnullvm@0.52.6
windows_i686_msvc@0.42.2
windows_i686_msvc@0.48.5
windows_i686_msvc@0.52.6
windows_x86_64_gnu@0.42.2
windows_x86_64_gnu@0.48.5
windows_x86_64_gnu@0.52.6
windows_x86_64_gnullvm@0.42.2
windows_x86_64_gnullvm@0.48.5
windows_x86_64_gnullvm@0.52.6
windows_x86_64_msvc@0.42.2
windows_x86_64_msvc@0.48.5
windows_x86_64_msvc@0.52.6
winnow@0.6.13
x11-clipboard@0.8.1
x11rb@0.12.0
x11rb-protocol@0.12.0
xmlparser@0.13.6
xmlwriter@0.1.0
xterm-query@0.3.0
xterm-query@0.4.0
yaml-rust@0.4.5
zune-inflate@0.2.54
"

inherit bash-completion-r1 cargo

DESCRIPTION="A new way to see and navigate directory trees"
HOMEPAGE="https://dystroy.org/broot/ https://github.com/Canop/broot"
SRC_URI="https://github.com/Canop/broot/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 BSD-2 BSD LGPL-3+ MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64"
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
	local myfeatures=( $(usev X clipboard) trash )

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

	local build_dir=( "$(cargo_target_dir)"/build/${PN}-*/out )
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
