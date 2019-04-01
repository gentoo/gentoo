# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.6.8
ansi_term-0.11.0
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.24
bitflags-1.0.4
byteorder-1.2.6
cc-1.0.25
cfg-if-0.1.6
clap-2.32.0
cpp_demangle-0.2.12
csv-1.0.2
csv-core-0.1.4
encode_unicode-0.3.5
env_logger-0.6.1
failure-0.1.3
failure_derive-0.1.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
glob-0.2.11
goblin-0.0.19
hexplay-0.2.1
humantime-1.1.1
lazy_static-1.1.0
libc-0.2.43
log-0.4.5
memchr-2.1.0
memrange-0.1.3
metagoblin-0.1.1
plain-0.2.3
prettytable-rs-0.8.0
proc-macro2-0.4.20
quick-error-1.2.2
quote-0.6.8
rand-0.3.22
rand-0.4.3
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.5
regex-syntax-0.6.2
rustc-demangle-0.1.9
rustc-serialize-0.3.24
rustc_version-0.2.3
scroll-0.9.2
scroll_derive-0.9.5
semver-0.9.0
semver-parser-0.7.0
serde-1.0.80
strsim-0.7.0
structopt-0.2.12
structopt-derive-0.2.12
syn-0.15.13
synstructure-0.10.0
term-0.5.1
termcolor-0.3.6
termcolor-1.0.4
termion-1.5.1
textwrap-0.10.0
theban_interval_tree-0.7.1
thread_local-0.3.6
time-0.1.40
ucd-util-0.1.1
unicode-width-0.1.5
unicode-xid-0.1.0
utf8-ranges-1.0.1
vec_map-0.8.1
version_check-0.1.5
winapi-0.3.6
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
wincolor-1.0.1
"

inherit cargo

EGIT_COMMIT="9b29a829bc41bbb9c8ca2d0ecfef8472e7aeda81"

DESCRIPTION="Binary file analysis tool"
HOMEPAGE="https://github.com/m4b/bingrep"
SRC_URI="https://github.com/m4b/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=""

QA_FLAGS_IGNORED="/usr/bin/bingrep"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_install() {
	cargo_src_install
	einstalldocs
}
