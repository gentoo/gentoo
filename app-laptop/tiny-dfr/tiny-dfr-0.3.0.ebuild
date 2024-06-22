# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
aho-corasick@1.0.5
anyhow@1.0.75
approx@0.5.1
autocfg@1.1.0
bitflags@1.3.2
bitflags@2.4.0
block@0.1.6
bytemuck@1.14.0
bytemuck_derive@1.5.0
byteorder@1.4.3
cairo-rs@0.18.5
cairo-sys-rs@0.18.0
cast@0.3.0
cc@1.0.83
cfg-expr@0.15.5
cfg-if@1.0.0
crossbeam-channel@0.5.8
crossbeam-deque@0.8.3
crossbeam-epoch@0.9.15
crossbeam-utils@0.8.16
cssparser@0.31.2
cssparser-macros@0.6.1
data-url@0.3.0
derive_more@0.99.17
drm@0.11.1
drm-ffi@0.7.1
drm-fourcc@2.2.0
drm-sys@0.6.1
dtoa@1.0.9
dtoa-short@0.3.4
either@1.9.0
encoding_rs@0.8.33
equivalent@1.0.1
errno@0.3.8
float-cmp@0.9.0
form_urlencoded@1.2.0
freetype-rs@0.32.0
freetype-sys@0.17.0
futf@0.1.5
futures-channel@0.3.28
futures-core@0.3.28
futures-executor@0.3.28
futures-io@0.3.28
futures-macro@0.3.28
futures-task@0.3.28
futures-util@0.3.28
fxhash@0.2.1
gdk-pixbuf@0.18.0
gdk-pixbuf-sys@0.18.0
getrandom@0.2.10
gio@0.18.1
gio-sys@0.18.1
glib@0.18.1
glib-macros@0.18.0
glib-sys@0.18.1
gobject-sys@0.18.0
hashbrown@0.14.0
heck@0.4.1
hermit-abi@0.3.2
idna@0.4.0
indexmap@2.0.0
input@0.8.3
input-linux@0.6.0
input-linux-sys@0.8.0
input-sys@1.17.0
io-lifetimes@1.0.11
itertools@0.11.0
itoa@1.0.9
language-tags@0.3.2
lazy_static@1.4.0
libc@0.2.152
librsvg@2.57.1
libudev-sys@0.1.4
linux-raw-sys@0.4.13
linux-raw-sys@0.6.4
locale_config@0.3.0
lock_api@0.4.10
log@0.4.20
mac@0.1.1
malloc_buf@0.0.6
markup5ever@0.11.0
matrixmultiply@0.3.7
memchr@2.6.3
memoffset@0.7.1
memoffset@0.9.0
nalgebra@0.32.3
nalgebra-macros@0.2.1
new_debug_unreachable@1.0.4
nix@0.26.4
nix@0.27.1
num-complex@0.4.4
num-integer@0.1.45
num-rational@0.4.1
num-traits@0.2.16
num_cpus@1.16.0
objc@0.2.7
objc-foundation@0.1.1
objc_id@0.1.1
once_cell@1.18.0
pango@0.18.0
pango-sys@0.18.0
pangocairo@0.18.0
pangocairo-sys@0.18.0
parking_lot@0.12.1
parking_lot_core@0.9.8
paste@1.0.14
percent-encoding@2.3.0
phf@0.10.1
phf_codegen@0.10.0
phf_generator@0.10.0
phf_macros@0.10.0
phf_shared@0.10.0
pin-project-lite@0.2.13
pin-utils@0.1.0
pkg-config@0.3.27
ppv-lite86@0.2.17
precomputed-hash@0.1.1
privdrop@0.5.4
proc-macro-crate@1.3.1
proc-macro-error@1.0.4
proc-macro-error-attr@1.0.4
proc-macro-hack@0.5.20+deprecated
proc-macro2@1.0.66
quote@1.0.33
rand@0.8.5
rand_chacha@0.3.1
rand_core@0.6.4
rawpointer@0.2.1
rayon@1.7.0
rayon-core@1.11.0
rctree@0.5.0
redox_syscall@0.3.5
regex@1.9.5
regex-automata@0.3.8
regex-syntax@0.7.5
rgb@0.8.36
rustix@0.38.30
safe_arch@0.7.1
scopeguard@1.2.0
selectors@0.25.0
serde@1.0.188
serde_derive@1.0.188
serde_spanned@0.6.4
servo_arc@0.3.0
simba@0.8.1
siphasher@0.3.11
slab@0.4.9
smallvec@1.11.0
stable_deref_trait@1.2.0
string_cache@0.8.7
string_cache_codegen@0.5.2
syn@1.0.109
syn@2.0.32
system-deps@6.1.1
target-lexicon@0.12.11
tendril@0.4.3
thiserror@1.0.48
thiserror-impl@1.0.48
tiny-dfr@0.3.0
tinyvec@1.6.0
tinyvec_macros@0.1.1
toml@0.7.8
toml@0.8.8
toml_datetime@0.6.5
toml_edit@0.19.15
toml_edit@0.21.0
typenum@1.16.0
udev@0.7.0
unicode-bidi@0.3.13
unicode-ident@1.0.11
unicode-normalization@0.1.22
url@2.4.1
utf-8@0.7.6
version-compare@0.1.1
version_check@0.9.4
wasi@0.11.0+wasi-snapshot-preview1
wide@0.7.11
winapi@0.3.9
winapi-i686-pc-windows-gnu@0.4.0
winapi-x86_64-pc-windows-gnu@0.4.0
windows-sys@0.48.0
windows-sys@0.52.0
windows-targets@0.48.5
windows-targets@0.52.0
windows_aarch64_gnullvm@0.48.5
windows_aarch64_gnullvm@0.52.0
windows_aarch64_msvc@0.48.5
windows_aarch64_msvc@0.52.0
windows_i686_gnu@0.48.5
windows_i686_gnu@0.52.0
windows_i686_msvc@0.48.5
windows_i686_msvc@0.52.0
windows_x86_64_gnu@0.48.5
windows_x86_64_gnu@0.52.0
windows_x86_64_gnullvm@0.48.5
windows_x86_64_gnullvm@0.52.0
windows_x86_64_msvc@0.48.5
windows_x86_64_msvc@0.52.0
winnow@0.5.15
xml5ever@0.17.0
"

inherit cargo udev systemd linux-info

DESCRIPTION="The most basic dynamic function row daemon possible"
HOMEPAGE="https://github.com/WhatAmISupposedToPutHere/tiny-dfr"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/WhatAmISupposedToPutHere/tiny-dfr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

DEPEND="
	dev-libs/libinput
	x11-libs/pango
	x11-libs/gdk-pixbuf
"

RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/tiny-dfr"
QA_PRESTRIPPED="usr/bin/tiny-dfr"

pkg_pretend() {
	local CONFIG_CHECK="~INPUT_UINPUT"
	[[ ${MERGE_TYPE} != buildonly ]] && check_extra_config
}

src_install() {
	cargo_src_install

	insinto /usr/share/tiny-dfr
	doins share/tiny-dfr/*

	udev_dorules etc/udev/rules.d/*
	systemd_dounit etc/systemd/system/tiny-dfr.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
