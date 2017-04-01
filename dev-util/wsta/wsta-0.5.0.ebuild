# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
argparse-0.2.1
bitflags-0.7.0
byteorder-0.5.3
cfg-if-0.1.0
config-0.1.3
cookie-0.2.5
gcc-0.3.40
gdi32-sys-0.2.0
hpack-0.2.0
httparse-1.2.1
hyper-0.9.14
idna-0.1.0
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-0.2.2
libc-0.2.18
libressl-pnacl-sys-2.1.6
log-0.3.6
matches-0.1.4
mime-0.2.2
net2-0.2.26
nom-1.0.1
num_cpus-1.2.0
openssl-0.7.14
openssl-sys-0.7.17
openssl-sys-extras-0.7.14
openssl-verify-0.1.0
pkg-config-0.3.8
pnacl-build-helper-1.4.10
rand-0.3.15
rustc-serialize-0.3.22
rustc_version-0.1.7
semver-0.1.20
solicit-0.4.4
tempdir-0.3.5
time-0.1.35
traitobject-0.0.1
typeable-0.1.2
unicase-1.4.0
unicode-bidi-0.2.3
unicode-normalization-0.1.2
url-1.2.4
user32-sys-0.2.0
websocket-0.17.1
winapi-0.2.8
winapi-build-0.1.1
ws2_32-sys-0.2.1
xdg-2.0.0
"

inherit cargo

DESCRIPTION="A CLI development tool for WebSocket APIs"
HOMEPAGE="https://github.com/esphen/wsta/"
SRC_URI="https://github.com/esphen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/openssl:*"
DEPEND="${RDEPEND}
	dev-util/cargo
	"

src_test() {
	debug-print-function ${FUNCNAME} "$0"

	export CARGO_HOME="${ECARGO_HOME}"

	cargo test --release || die "Tests failed"
}

src_install() {
	cargo_src_install || die "Installation failed"

	einstalldocs
	doman ${PN}.1
}
