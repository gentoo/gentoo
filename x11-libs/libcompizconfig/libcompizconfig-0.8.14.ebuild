# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="CompizConfig plugin required for compizconfig-settings-manager"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxml2
	dev-libs/protobuf
	x11-libs/libX11
	>=x11-wm/compiz-0.8
	<x11-wm/compiz-0.9
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.41
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
