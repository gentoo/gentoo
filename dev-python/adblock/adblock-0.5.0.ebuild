# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adblock-0.3.13
addr-0.14.0
adler-1.0.2
aho-corasick-0.7.18
autocfg-1.0.1
base64-0.13.0
bitflags-1.2.1
byteorder-1.4.3
cfg-if-1.0.0
crc32fast-1.2.1
ctor-0.1.20
either-1.6.1
flate2-1.0.20
form_urlencoded-1.0.1
ghost-0.1.2
idna-0.2.2
indoc-0.3.6
indoc-impl-0.3.6
instant-0.1.9
inventory-0.1.10
inventory-impl-0.1.10
itertools-0.9.0
libc-0.2.93
lock_api-0.4.3
matches-0.1.8
memchr-2.4.0
miniz_oxide-0.4.4
num-traits-0.2.14
once_cell-1.7.2
parking_lot-0.11.1
parking_lot_core-0.8.3
paste-0.1.18
paste-impl-0.1.18
percent-encoding-2.1.0
proc-macro-hack-0.5.19
proc-macro2-1.0.26
psl-2.0.18
psl-types-2.0.7
pyo3-0.13.2
pyo3-macros-0.13.2
pyo3-macros-backend-0.13.2
quote-1.0.9
redox_syscall-0.2.5
regex-1.5.4
regex-syntax-0.6.25
rmp-0.8.10
rmp-serde-0.13.7
scopeguard-1.1.0
seahash-3.0.7
serde-1.0.125
serde_derive-1.0.125
smallvec-1.6.1
syn-1.0.69
tinyvec-1.2.0
tinyvec_macros-0.1.0
twoway-0.2.1
unchecked-index-0.2.2
unicode-bidi-0.3.5
unicode-normalization-0.1.17
unicode-xid-0.2.1
unindent-0.1.7
url-2.2.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"
PYTHON_COMPAT=( python3_{8,9} )

inherit cargo python-r1

DESCRIPTION="Python wrapper for Brave's adblocking library, which is written in Rust"
HOMEPAGE="https://github.com/ArniDagur/python-adblock"
SRC_URI="https://github.com/ArniDagur/python-adblock/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
S="${WORKDIR}/python-${P}"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	dev-util/maturin
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

QA_FLAGS_IGNORED="usr/lib.*/libadblock.so
	usr/lib/python3.*/site-packages/adblock/adblock.abi3.so"
QA_SONAME="${QA_FLAGS_IGNORED}"

src_compile() {
	maturin build $(usex debug "" --release) --no-sdist || die
	unzip "target/wheels/${P}-*.whl" adblock/adblock.abi3.so || die
}

src_install() {
	python_foreach_impl python_domodule adblock
	dolib.so target/release/libadblock.so
	dodoc CHANGELOG.md README.md
}

src_test() {
	python_foreach_impl epytest
}
