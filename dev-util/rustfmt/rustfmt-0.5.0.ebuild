# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.5.1
unicode-xid-0.0.3
log-0.3.6
term-0.2.14
rustc-serialize-0.3.19
memchr-0.1.11
toml-0.1.28
bitflags-0.5.0
strings-0.0.1
getopts-0.2.14
diff-0.1.9
mempool-0.3.1
unicode-segmentation-0.1.2
term-0.4.4
syntex_syntax-0.32.0
winapi-0.2.6
winapi-build-0.1.1
kernel32-sys-0.2.1
utf8-ranges-0.1.3
regex-0.1.63
regex-syntax-0.3.1
rustfmt-0.5.0
env_logger-0.3.3
libc-0.2.9
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
