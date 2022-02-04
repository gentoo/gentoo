# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
Inflector-0.11.4
ahash-0.4.7
aho-corasick-0.7.18
async-trait-0.1.51
autocfg-1.0.1
bitflags-1.3.2
block-0.1.6
block-buffer-0.9.0
bytes-1.1.0
cassowary-0.3.0
cc-1.0.70
cfg-if-1.0.0
chrono-0.4.19
cpufeatures-0.2.1
dashmap-4.0.2
digest-0.9.0
dlv-list-0.2.3
find-crate-0.6.3
fluent-0.16.0
fluent-bundle-0.15.1
fluent-langneg-0.13.0
fluent-syntax-0.11.0
generic-array-0.14.4
getopts-0.2.21
getrandom-0.2.3
greetd_ipc-0.8.0
hashbrown-0.9.1
hermit-abi-0.1.19
i18n-config-0.4.2
i18n-embed-0.13.0
i18n-embed-fl-0.6.0
i18n-embed-impl-0.8.0
instant-0.1.11
intl-memoizer-0.5.1
intl_pluralrules-7.0.1
itoa-0.4.8
lazy_static-1.4.0
libc-0.2.103
locale_config-0.3.0
lock_api-0.4.5
log-0.4.14
malloc_buf-0.0.6
memchr-2.4.1
memoffset-0.6.4
mio-0.7.13
miow-0.3.7
nix-0.23.0
ntapi-0.3.6
num-integer-0.1.44
num-traits-0.2.14
num_cpus-1.13.0
numtoa-0.1.0
objc-0.2.7
objc-foundation-0.1.1
objc_id-0.1.1
once_cell-1.8.0
opaque-debug-0.3.0
ordered-multimap-0.3.1
ouroboros-0.9.5
ouroboros_macro-0.9.5
parking_lot-0.11.2
parking_lot_core-0.8.5
pin-project-lite-0.2.7
ppv-lite86-0.2.10
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.29
pure-rust-locales-0.5.6
quote-1.0.9
rand-0.8.4
rand_chacha-0.3.1
rand_core-0.6.3
rand_hc-0.3.1
redox_syscall-0.2.10
redox_termios-0.1.2
regex-1.5.4
regex-syntax-0.6.25
rust-embed-6.2.0
rust-embed-impl-6.1.0
rust-embed-utils-7.0.0
rust-ini-0.17.0
rustc-hash-1.1.0
ryu-1.0.5
same-file-1.0.6
scopeguard-1.1.0
serde-1.0.130
serde_derive-1.0.130
serde_json-1.0.68
sha2-0.9.8
signal-hook-registry-1.4.0
smallvec-1.7.0
smart-default-0.6.0
smawk-0.3.1
stable_deref_trait-1.2.0
strsim-0.10.0
syn-1.0.78
termion-1.5.6
textwrap-0.14.2
thiserror-1.0.29
thiserror-impl-1.0.29
time-0.1.44
tinystr-0.3.4
tokio-1.12.0
tokio-macros-1.4.1
toml-0.5.8
tui-0.16.0
type-map-0.4.0
typenum-1.14.0
unic-langid-0.9.0
unic-langid-impl-0.9.0
unicode-linebreak-0.1.2
unicode-segmentation-1.8.0
unicode-width-0.1.9
unicode-xid-0.2.2
version_check-0.9.3
walkdir-2.3.2
wasi-0.10.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
zeroize-1.4.2
"

inherit cargo

DESCRIPTION="TUI greeter for greetd login manager"
HOMEPAGE="https://github.com/apognu/tuigreet"

SRC_URI="https://github.com/apognu/tuigreet/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

PATCHES=(
	"${FILESDIR}/${P}-power-command-notify.patch"
)

QA_FLAGS_IGNORED="usr/bin/tuigreet"

LICENSE="Apache-2.0 Boost-1.0 GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv"

RDEPEND="gui-libs/greetd"
