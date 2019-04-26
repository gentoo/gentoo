# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.6.8
ansi_term-0.11.0
atty-0.2.11
bitflags-1.0.4
cc-1.0.25
cfg-if-0.1.6
clap-2.32.0
fblog-1.2.0
hlua-0.4.1
itoa-0.4.3
lazy_static-1.1.0
libc-0.2.43
lua52-sys-0.1.2
maplit-1.0.1
memchr-2.1.0
pkg-config-0.3.14
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.5
regex-syntax-0.6.2
ryu-0.2.6
serde-1.0.80
serde_json-1.0.32
strsim-0.7.0
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
ucd-util-0.1.1
unicode-width-0.1.5
utf8-ranges-1.0.1
vec_map-0.8.1
version_check-0.1.5
winapi-0.3.6
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=virtual/rust-1.29.1"

DOCS=( README.org )

QA_FLAGS_IGNORED="/usr/bin/fblog"

src_install() {
	cargo_src_install --path=.
	einstalldocs
}
