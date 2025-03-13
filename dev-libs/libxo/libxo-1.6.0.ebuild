# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Library for Generating Text, XML, JSON, and HTML Output"
HOMEPAGE="https://github.com/Juniper/libxo"
SRC_URI="https://github.com/Juniper/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/xo_syslog.patch
)

src_configure() {
	econf --enable-static=$(usex static-libs)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
