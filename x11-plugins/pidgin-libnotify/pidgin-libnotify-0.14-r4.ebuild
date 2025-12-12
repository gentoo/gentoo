# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pidgin-libnotify provides popups for pidgin via a libnotify interface"
HOMEPAGE="https://gaim-libnotify.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/gaim-libnotify/${P}.tar.gz
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}-4.debian.tar.gz"

inherit autotools

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="nls debug"

RDEPEND="
	dev-libs/glib:2
	net-im/pidgin[gui]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	>=x11-libs/libnotify-0.3.2
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}/debian/patches"
	"${FILESDIR}/${P}-libnotify-0.7.patch"
	"${FILESDIR}/${P}-configure.patch"
	"${FILESDIR}/${P}-fix-includes.patch"
)

src_prepare() {
	default
	eautoreconf
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
