# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cargo

DESCRIPTION="A CLI development tool for WebSocket APIs"
HOMEPAGE="https://github.com/esphen/wsta/"
SRC_URI="https://github.com/esphen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/openssl:*"
DEPEND="${RDEPEND}
	dev-util/cargo
	"

src_compile() {
	cargo build --release || die "Compilation failed"
}

src_test() {
	cargo test || die "Tests failed"
}

src_install() {
	einstalldocs

	dobin target/release/${PN}
	doman ${PN}.1
}
