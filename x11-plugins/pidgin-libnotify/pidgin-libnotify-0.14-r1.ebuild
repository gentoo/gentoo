# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="pidgin-libnotify provides popups for pidgin via a libnotify interface"
HOMEPAGE="http://gaim-libnotify.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaim-libnotify/${P}.tar.gz
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}-4.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls debug"

RDEPEND=">=x11-libs/libnotify-0.3.2
	net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}/debian/patches"
	"${FILESDIR}/${P}-libnotify-0.7.patch"
)

src_prepare() {
	default
	sed -i -e '/CFLAGS/s:-g3::' configure || die "sed failed"
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
