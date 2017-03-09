# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.5.3
bitflags-0.7.0
diff-0.1.9
env_logger-0.3.5
getopts-0.2.14
itertools-0.4.19
kernel32-sys-0.2.2
libc-0.2.16
log-0.3.6
memchr-0.1.11
multimap-0.3.0
regex-0.1.77
regex-syntax-0.3.5
rustc-serialize-0.3.19
rustfmt-0.6.3
strings-0.0.1
syntex_errors-0.44.0
syntex_pos-0.44.0
syntex_syntax-0.44.1
term-0.4.4
thread-id-2.0.0
thread_local-0.2.7
toml-0.1.30
unicode-segmentation-0.1.2
unicode-xid-0.0.3
utf8-ranges-0.1.3
walkdir-0.1.8
winapi-0.2.8
winapi-build-0.1.1
"

inherit cargo

DESCRIPTION="Tool to find and fix Rust formatting issues"
HOMEPAGE="https://github.com/rust-lang-nursery/rustfmt"
SRC_URI="$(cargo_crate_uris ${CRATES})"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/rust-1.8.0"
RDEPEND=""
