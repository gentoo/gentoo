# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

DESCRIPTION="Command-line client for WebSockets, like netcat, with socat-like functions"
HOMEPAGE="https://github.com/vi/websocat"
SRC_URI="
	https://github.com/vi/websocat/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~arthurzam/distfiles/net-misc/${PN}/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl"
RESTRICT+=" test"

RDEPEND="
	ssl? (
		dev-libs/openssl:0=
	)
"
DEPEND="
	${RUST_DEPEND}
	${RDEPEND}
"
QA_FLAGS_IGNORED="/usr/bin/websocat"

src_configure() {
	local myfeatures=(
		$(usex ssl ssl '')
		seqpacket
		signal_handler
		tokio-process
		unix_stdio
	)
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install
	dodoc *.md
}
