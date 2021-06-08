# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library which can read Excel (xls) files"
HOMEPAGE="https://github.com/libxls/libxls"
SRC_URI="https://github.com/libxls/libxls/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/8" # libxlsreader.so.8
KEYWORDS="amd64 x86"

BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

RESTRICT="test" # test driver is missing

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-asprintf.patch
)

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
