# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library for generation and use of macaroons authorization credentials"
HOMEPAGE="https://github.com/rescrv/libmacaroons"
SRC_URI="https://github.com/rescrv/libmacaroons/archive/refs/tags/releases/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-releases-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/json-c:=
	dev-libs/libsodium:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-json-c.patch
	"${FILESDIR}"/${P}-no-python.patch
	"${FILESDIR}"/${P}-hex-encoding.patch
	"${FILESDIR}"/${P}-deserialize-memleak.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-json-support
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
