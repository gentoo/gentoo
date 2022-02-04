# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
addr2line-0.17.0
adler-1.0.2
arrayref-0.3.6
arrayvec-0.7.2
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.63
bitflags-1.3.2
blake3-1.2.0
cc-1.0.72
cfg-if-1.0.0
clap-3.0.0-beta.5
clap_derive-3.0.0-beta.5
color-eyre-0.5.11
color-spantrace-0.1.6
constant_time_eq-0.1.5
digest-0.9.0
dirs-3.0.2
dirs-sys-0.3.6
dtoa-0.4.8
eyre-0.6.5
generic-array-0.14.4
getrandom-0.2.3
gimli-0.26.1
hashbrown-0.11.2
heck-0.3.3
hermit-abi-0.1.19
indenter-0.3.3
indexmap-1.7.0
json-0.12.4
lazy_static-1.4.0
libc-0.2.108
linked-hash-map-0.5.4
memchr-2.4.1
miniz_oxide-0.4.4
object-0.27.1
once_cell-1.8.0
os_str_bytes-4.2.0
owo-colors-1.3.0
pin-project-lite-0.2.7
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.32
quote-1.0.10
redox_syscall-0.2.10
redox_users-0.4.0
rustc-demangle-0.1.21
same-file-1.0.6
semver-1.0.4
serde-1.0.130
serde_derive-1.0.130
serde_yaml-0.8.21
sharded-slab-0.1.4
strsim-0.10.0
syn-1.0.81
termcolor-1.1.2
textwrap-0.14.2
thread_local-1.1.3
tracing-0.1.29
tracing-attributes-0.1.18
tracing-core-0.1.21
tracing-error-0.1.2
tracing-subscriber-0.2.25
typenum-1.14.0
unicase-2.6.0
unicode-segmentation-1.8.0
unicode-width-0.1.9
unicode-xid-0.2.2
version_check-0.9.3
void-1.0.2
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xdg-2.4.0
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
