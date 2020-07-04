# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
ansi_term-0.11.0
ansi_term-0.12.1
atty-0.2.13
bitflags-1.1.0
cc-1.0.45
clap-2.33.0
fblog-1.4.1
hlua-0.4.1
itoa-0.4.4
lazy_static-1.4.0
libc-0.2.62
lua52-sys-0.1.2
maplit-1.0.2
memchr-2.2.1
pkg-config-0.3.16
regex-1.3.1
regex-syntax-0.6.12
ryu-1.0.0
serde-1.0.100
serde_json-1.0.40
strsim-0.8.0
textwrap-0.11.0
thread_local-0.3.6
unicode-width-0.1.6
vec_map-0.8.1
winapi-0.3.8
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

DOCS=( README.org sample.json.log )

QA_FLAGS_IGNORED="/usr/bin/fblog"

src_install() {
	cargo_src_install
	einstalldocs
}
