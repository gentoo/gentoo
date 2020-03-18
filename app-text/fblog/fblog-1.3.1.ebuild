# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.3
ansi_term-0.11.0
atty-0.2.11
bitflags-1.0.4
cc-1.0.37
clap-2.33.0
fblog-1.3.1
hlua-0.4.1
itoa-0.4.4
lazy_static-1.3.0
libc-0.2.54
lua52-sys-0.1.2
maplit-1.0.1
memchr-2.2.0
numtoa-0.1.0
pkg-config-0.3.14
redox_syscall-0.1.54
redox_termios-0.1.1
regex-1.1.6
regex-syntax-0.6.6
ryu-0.2.8
serde-1.0.91
serde_json-1.0.39
strsim-0.8.0
termion-1.5.2
textwrap-0.11.0
thread_local-0.3.6
ucd-util-0.1.3
unicode-width-0.1.5
utf8-ranges-1.0.2
vec_map-0.8.1
winapi-0.3.7
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 MIT Unlicense WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=virtual/rust-1.34.2"

DOCS=( README.org sample.json.log )

QA_FLAGS_IGNORED="/usr/bin/fblog"

src_install() {
	cargo_src_install
	einstalldocs
}
