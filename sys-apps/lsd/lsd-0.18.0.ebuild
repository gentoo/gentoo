# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
ansi_term-0.11.0
ansi_term-0.12.1
assert_cmd-1.0.1
assert_fs-1.0.0
atty-0.2.14
autocfg-1.0.0
bitflags-1.2.1
bstr-0.2.12
cfg-if-0.1.10
chrono-0.4.11
chrono-humanize-0.0.11
clap-2.33.0
crossbeam-channel-0.4.2
crossbeam-utils-0.7.2
difference-2.0.0
doc-comment-0.3.3
float-cmp-0.6.0
fnv-1.0.6
getrandom-0.1.14
glob-0.3.0
globset-0.4.5
globwalk-0.7.3
hermit-abi-0.1.10
ignore-0.4.14
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.68
log-0.4.8
lscolors-0.7.0
maybe-uninit-2.0.0
memchr-2.3.3
normalize-line-endings-0.3.0
num-integer-0.1.42
num-traits-0.2.11
ppv-lite86-0.2.6
predicates-1.0.4
predicates-core-1.0.0
predicates-tree-1.0.0
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
regex-1.3.6
regex-syntax-0.6.17
remove_dir_all-0.5.2
same-file-1.0.6
strsim-0.8.0
tempfile-3.1.0
term_grid-0.1.7
term_size-0.3.1
terminal_size-0.1.12
textwrap-0.11.0
thread_local-1.0.1
time-0.1.42
treeline-0.1.0
unicode-width-0.1.7
users-0.10.0
vec_map-0.8.1
version_check-0.9.1
wait-timeout-0.2.0
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
wild-2.0.2
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.4
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
