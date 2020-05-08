# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
anyhow-1.0.26
atty-0.2.14
bitflags-1.2.1
cargo-tree-0.29.0
cargo_metadata-0.9.1
clap-2.33.0
fixedbitset-0.1.9
heck-0.3.1
hermit-abi-0.1.6
itoa-0.4.5
lazy_static-1.4.0
libc-0.2.66
ordermap-0.3.5
petgraph-0.4.13
proc-macro-error-0.4.5
proc-macro-error-attr-0.4.5
proc-macro2-1.0.8
quote-1.0.2
rustversion-1.0.2
ryu-1.0.2
semver-0.9.0
semver-parser-0.7.0
serde-1.0.104
serde_derive-1.0.104
serde_json-1.0.45
strsim-0.8.0
structopt-0.3.8
structopt-derive-0.4.1
syn-1.0.14
syn-mid-0.4.0
textwrap-0.11.0
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.0
vec_map-0.8.1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Cargo subcommand that visualizes crate dependency graph in a tree-like format"
HOMEPAGE="https://github.com/sfackler/cargo-tree"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE=""

BDEPEND=""
RDEPEND=""
DEPEND=""

QA_FLAGS_IGNORED="usr/bin/cargo-tree"

src_install() {
	cargo_src_install
	einstalldocs
}
