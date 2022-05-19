# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
addr2line-0.17.0
adler-1.0.2
arrayref-0.3.6
arrayvec-0.7.2
atty-0.2.14
autocfg-1.1.0
backtrace-0.3.65
bitflags-1.3.2
blake3-1.3.1
block-buffer-0.10.2
camino-1.0.8
cc-1.0.73
cfg-if-1.0.0
clap-3.1.18
clap_complete-3.1.4
clap_derive-3.1.18
clap_lex-0.2.0
clap_mangen-0.1.6
color-eyre-0.6.1
colored-2.0.0
constant_time_eq-0.1.5
crypto-common-0.1.3
digest-0.10.3
dirs-4.0.0
dirs-sys-0.3.7
eyre-0.6.8
generic-array-0.14.5
getrandom-0.2.6
gimli-0.26.1
hashbrown-0.11.2
heck-0.4.0
hermit-abi-0.1.19
indenter-0.3.3
indexmap-1.8.1
json-0.12.4
lazy_static-1.4.0
libc-0.2.125
linked-hash-map-0.5.4
log-0.4.17
memchr-2.5.0
miniz_oxide-0.5.1
object-0.28.4
once_cell-1.10.0
os_str_bytes-6.0.0
owo-colors-3.4.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.38
quote-1.0.18
redox_syscall-0.2.13
redox_users-0.4.3
roff-0.2.1
rustc-demangle-0.1.21
ryu-1.0.9
same-file-1.0.6
semver-1.0.9
serde-1.0.137
serde_derive-1.0.137
serde_yaml-0.8.24
strsim-0.10.0
subtle-2.4.1
syn-1.0.94
termcolor-1.1.3
terminal_size-0.1.17
textwrap-0.15.0
thiserror-1.0.31
thiserror-impl-1.0.31
typenum-1.15.0
unicode-xid-0.2.3
version_check-0.9.4
void-1.0.2
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xdg-2.4.1
yaml-rust-0.4.5
"

inherit cargo

DESCRIPTION="Utility for declarative installation of programs"
HOMEPAGE="https://github.com/DanySpin97/rinstall"
SRC_URI="https://github.com/DanySpin97/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

QA_FLAGS_IGNORED="usr/bin/rinstall"

src_install() {
	cargo_src_install

	einstalldocs
}
