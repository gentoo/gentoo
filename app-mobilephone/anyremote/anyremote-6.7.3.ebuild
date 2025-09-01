# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bluetooth, infrared or cable remote control service"
HOMEPAGE="https://anyremote.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth dbus zeroconf"

RDEPEND="
	dev-libs/glib:2
	x11-libs/libX11
	x11-libs/libXtst
	bluetooth? ( net-wireless/bluez:= )
	dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)
	zeroconf? ( net-dns/avahi )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fix_doublefree.patch
	"${FILESDIR}"/${PN}-6.7.3-fix_gcc15.patch
)

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local myeconfargs=(
		--docdir="/usr/share/doc/${PF}/"
		$(use_enable bluetooth)
		$(use_enable dbus)
		$(use_enable zeroconf avahi)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	mv "${ED}"/usr/share/doc/${PF}/{doc-html,html} || die
	gunzip "${ED}"/usr/share/man/man1/anyremote.1.gz || die
}
