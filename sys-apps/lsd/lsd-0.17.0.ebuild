# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
ansi_term-0.11.0
ansi_term-0.12.1
assert_cmd-0.11.1
assert_fs-0.11.3
atty-0.2.13
autocfg-0.1.7
bitflags-1.2.1
bstr-0.2.8
c2-chacha-0.2.3
cfg-if-0.1.10
chrono-0.4.9
chrono-humanize-0.0.11
clap-2.33.0
crossbeam-channel-0.3.9
crossbeam-utils-0.6.6
difference-2.0.0
escargot-0.4.0
float-cmp-0.4.0
fnv-1.0.6
getrandom-0.1.12
glob-0.3.0
globset-0.4.4
globwalk-0.5.0
ignore-0.4.10
itoa-0.4.4
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.65
log-0.4.8
lscolors-0.6.0
lsd-0.17.0
memchr-2.2.1
normalize-line-endings-0.2.2
num-integer-0.1.41
num-traits-0.2.8
ppv-lite86-0.2.6
predicates-1.0.1
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro2-1.0.6
quote-1.0.2
rand-0.7.2
rand_chacha-0.2.1
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
regex-1.3.1
regex-syntax-0.6.12
remove_dir_all-0.5.2
ryu-1.0.2
same-file-1.0.5
serde-1.0.101
serde_derive-1.0.101
serde_json-1.0.41
strsim-0.8.0
syn-1.0.5
tempfile-3.1.0
term_grid-0.1.7
term_size-0.3.1
terminal_size-0.1.8
textwrap-0.11.0
thread_local-0.3.6
time-0.1.42
treeline-0.1.0
unicode-width-0.1.6
unicode-xid-0.2.0
users-0.9.1
vec_map-0.8.1
version_check-0.9.1
walkdir-2.2.9
wasi-0.7.0
wild-2.0.2
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
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
