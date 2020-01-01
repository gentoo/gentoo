# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
ansi_term-0.11.0
arrayref-0.3.5
arrayvec-0.5.1
atty-0.2.13
backtrace-0.3.40
backtrace-sys-0.1.32
base64-0.10.1
bingrep-0.8.1
bitflags-1.2.1
blake2b_simd-0.5.9
bstr-0.2.8
byteorder-1.3.2
cc-1.0.47
cfg-if-0.1.10
clap-2.33.0
cloudabi-0.0.3
constant_time_eq-0.1.4
cpp_demangle-0.2.13
crossbeam-utils-0.6.6
csv-1.1.1
csv-core-0.1.6
dirs-1.0.5
encode_unicode-0.3.6
env_logger-0.7.1
failure-0.1.6
failure_derive-0.1.6
fuchsia-cprng-0.1.1
glob-0.3.0
goblin-0.1.1
heck-0.3.1
hexplay-0.2.1
humantime-1.3.0
itoa-0.4.4
lazy_static-1.4.0
libc-0.2.65
log-0.4.8
memchr-2.2.1
memrange-0.1.3
metagoblin-0.3.0
plain-0.2.3
prettytable-rs-0.8.0
proc-macro-error-0.2.6
proc-macro2-1.0.6
quick-error-1.2.2
quote-1.0.2
rand-0.3.23
rand-0.4.6
rand_core-0.3.1
rand_core-0.4.2
rand_os-0.1.3
rdrand-0.4.0
redox_syscall-0.1.56
redox_users-0.3.1
regex-1.3.1
regex-automata-0.1.8
regex-syntax-0.6.12
rust-argon2-0.5.1
rustc-demangle-0.1.16
rustc-serialize-0.3.24
ryu-1.0.2
scroll-0.10.1
scroll_derive-0.10.1
serde-1.0.102
strsim-0.8.0
structopt-0.3.4
structopt-derive-0.3.4
syn-1.0.8
synstructure-0.12.3
term-0.5.2
termcolor-0.3.6
termcolor-1.0.5
textwrap-0.11.0
theban_interval_tree-0.7.1
thread_local-0.3.6
time-0.1.42
unicode-segmentation-1.6.0
unicode-width-0.1.6
unicode-xid-0.2.0
vec_map-0.8.1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
wincolor-1.0.2
"

inherit cargo


DESCRIPTION="Binary file analysis tool"
HOMEPAGE="https://github.com/m4b/bingrep"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 GPL-3 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=""

QA_FLAGS_IGNORED="usr/bin/bingrep"

src_install() {
	cargo_src_install
	einstalldocs
}
