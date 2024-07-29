# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="SANE backend for AirScan (eSCL) and WSD document scanners"
HOMEPAGE="https://github.com/alexpevzner/sane-airscan"
SRC_URI="https://github.com/alexpevzner/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libxml2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	net-dns/avahi
	net-libs/gnutls:=
"
RDEPEND="${DEPEND}
	media-gfx/sane-backends
"

PATCHES=(
	"${FILESDIR}/${PN}-0.99.27-makefile-fixes.patch"
)

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" COMPRESS= STRIP= install
}
