# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Cloudflare's PKI and TLS toolkit"
HOMEPAGE="https://github.com/cloudflare/cfssl"
SRC_URI="https://github.com/cloudflare/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-1 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hardened"

RDEPEND="!!dev-lang/mono" #File collision (bug 614364)

PATCHES=(
	"${FILESDIR}/${PN}-1.4.1-build-fix.patch"
)

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" emake VERSION="${PV}"
}

src_install() {
	dobin bin/*
	dodoc CHANGELOG README.md
}
