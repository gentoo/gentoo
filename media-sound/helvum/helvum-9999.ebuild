# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.15
ansi_term-0.11.0
anyhow-1.0.42
arrayvec-0.5.2
atty-0.2.14
autocfg-1.0.1
bindgen-0.59.1
bitflags-1.2.1
bitvec-0.19.5
cairo-rs-0.14.1
cairo-sys-rs-0.14.0
cc-1.0.69
cexpr-0.5.0
cfg-expr-0.8.1
cfg-if-0.1.10
cfg-if-1.0.0
clang-sys-1.2.0
clap-2.33.3
cookie-factory-0.3.2
either-1.6.1
env_logger-0.8.4
env_logger-0.9.0
errno-dragonfly-0.1.1
errno-0.2.7
field-offset-0.3.4
funty-1.1.0
futures-core-0.3.16
futures-executor-0.3.16
futures-channel-0.3.16
futures-io-0.3.16
futures-task-0.3.16
futures-util-0.3.16
gcc-0.3.55
gdk-pixbuf-sys-0.14.0
gdk-pixbuf-0.14.0
gdk4-sys-0.2.0
gdk4-0.2.0
gio-sys-0.14.0
gio-0.14.0
glib-macros-0.14.1
glib-sys-0.14.0
glib-0.14.2
glob-0.3.0
gobject-sys-0.14.0
graphene-rs-0.14.0
graphene-sys-0.14.0
gsk4-sys-0.2.0
gsk4-0.2.0
gtk4-macros-0.2.0
gtk4-sys-0.2.0
gtk4-0.2.0
heck-0.3.3
hermit-abi-0.1.19
humantime-2.1.0
itertools-0.10.1
lazycell-1.3.0
lazy_static-1.4.0
lexical-core-0.7.6
libc-0.2.98
libloading-0.7.0
libspa-sys-0.4.1
libspa-0.4.1
log-0.4.14
memchr-2.3.4
memoffset-0.6.4
nix-0.14.1
nom-6.2.1
once_cell-1.8.0
pango-sys-0.14.0
pango-0.14.0
peeking_take_while-0.1.2
pest-2.1.3
pin-project-lite-0.2.7
pin-utils-0.1.0
pipewire-sys-0.4.1
pipewire-0.4.1
pkg-config-0.3.19
proc-macro-crate-1.0.0
proc-macro-error-attr-1.0.4
proc-macro-error-1.0.4
proc-macro2-1.0.28
quote-1.0.9
radium-0.5.3
regex-syntax-0.6.25
regex-1.4.6
rustc-hash-1.1.0
rustc_version-0.3.3
ryu-1.0.5
semver-parser-0.10.2
semver-0.11.0
serde-1.0.127
shlex-1.0.0
signal-0.7.0
slab-0.4.4
smallvec-1.6.1
static_assertions-1.1.0
strsim-0.8.0
strum_macros-0.21.1
strum-0.21.0
syn-1.0.74
system-deps-3.2.0
tap-1.0.1
termcolor-1.1.2
textwrap-0.11.0
thiserror-impl-1.0.26
thiserror-1.0.26
toml-0.5.8
ucd-trie-0.1.3
unicode-segmentation-1.8.0
unicode-width-0.1.8
unicode-xid-0.2.2
vec_map-0.8.2
version-compare-0.0.11
version_check-0.9.3
void-1.0.2
which-3.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winapi-0.3.9
wyz-0.2.0
"

inherit cargo rust-toolchain desktop

if [[ ${PV} = "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/ryuukyu/helvum.git"
	inherit git-r3
else
	SRC_URI="$(cargo_crate_uris ${CRATES} ${P//_/-})"
	KEYWORDS="~amd64"
fi

DESCRIPTION="GTK-based patchbay for pipewire"
HOMEPAGE="https://gitlab.freedesktop.org/ryuukyu/helvum"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	gui-libs/gtk:4
	media-video/pipewire
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
		tar -xf "${DISTDIR}/${P//_/-}.crate" -C "${WORKDIR}" || die
	fi
}

src_install() {
	cargo_src_install
	make_desktop_entry ${PN} Helvum
}
