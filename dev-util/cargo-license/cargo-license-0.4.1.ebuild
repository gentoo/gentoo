# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.9.0
ansi_term-0.11.0
anyhow-1.0.36
atty-0.2.14
bitflags-1.2.1
bstr-0.2.14
byteorder-1.3.4
cargo-license-0.4.1
cargo_metadata-0.9.1
clap-2.33.3
csv-1.1.5
csv-core-0.1.10
getopts-0.2.21
heck-0.3.2
hermit-abi-0.1.17
itoa-0.4.7
lazy_static-1.4.0
libc-0.2.81
memchr-2.3.4
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.24
quote-1.0.8
quote-1.0.9
regex-automata-0.1.9
ryu-1.0.5
semver-0.9.0
semver-parser-0.7.0
serde-1.0.118
serde_derive-1.0.118
serde_json-1.0.60
strsim-0.8.0
structopt-0.3.21
structopt-derive-0.4.14
syn-1.0.56
syn-1.0.69
textwrap-0.11.0
toml-0.4.10
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
vec_map-0.8.2
version_check-0.9.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Cargo subcommand to see license of dependencies"
HOMEPAGE="https://github.com/onur/cargo-license"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="/usr/bin/cargo-license"

src_install() {
	cargo_src_install
	einstalldocs
}
