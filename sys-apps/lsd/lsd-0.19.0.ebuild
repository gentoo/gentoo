# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.13
ansi_term-0.11.0
ansi_term-0.12.1
arrayref-0.3.6
arrayvec-0.5.1
assert_cmd-1.0.1
assert_fs-1.0.0
atty-0.2.14
autocfg-1.0.1
base64-0.12.3
bitflags-1.2.1
blake2b_simd-0.5.10
bstr-0.2.13
cfg-if-0.1.10
chrono-0.4.15
chrono-humanize-0.0.11
clap-2.33.3
constant_time_eq-0.1.5
crossbeam-utils-0.7.2
difference-2.0.0
dirs-3.0.1
dirs-sys-0.3.5
doc-comment-0.3.3
dtoa-0.4.6
float-cmp-0.8.0
fnv-1.0.7
getrandom-0.1.15
glob-0.3.0
globset-0.4.5
globwalk-0.7.3
hermit-abi-0.1.16
human-sort-0.2.2
ignore-0.4.16
lazy_static-1.4.0
libc-0.2.77
linked-hash-map-0.5.3
log-0.4.11
lscolors-0.7.1
memchr-2.3.3
normalize-line-endings-0.3.0
num-integer-0.1.43
num-traits-0.2.12
ppv-lite86-0.2.9
predicates-1.0.5
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro2-1.0.24
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.3.9
regex-syntax-0.6.18
remove_dir_all-0.5.3
rust-argon2-0.8.2
same-file-1.0.6
serde-1.0.117
serde_derive-1.0.117
serde_yaml-0.8.13
strsim-0.8.0
syn-1.0.48
tempfile-3.1.0
term_grid-0.1.7
term_size-0.3.2
terminal_size-0.1.13
textwrap-0.11.0
thread_local-1.0.1
time-0.1.44
treeline-0.1.0
unicode-width-0.1.8
unicode-xid-0.2.1
users-0.11.0
vec_map-0.8.2
version_check-0.9.2
wait-timeout-0.2.0
walkdir-2.3.1
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wild-2.0.4
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xdg-2.1.0
yaml-rust-0.4.4
"

inherit cargo

DESCRIPTION="A modern ls with a lot of pretty colors and awesome icons"
HOMEPAGE="https://github.com/Peltoche/lsd"
SRC_URI="https://github.com/Peltoche/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=""

QA_FLAGS_IGNORED="/usr/bin/lsd"

src_install() {
	cargo_src_install
	einstalldocs
}
