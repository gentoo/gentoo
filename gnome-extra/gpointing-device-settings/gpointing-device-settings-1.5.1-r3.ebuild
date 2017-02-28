# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="A GTK+ based configuration utility for the synaptics driver"
HOMEPAGE="https://wiki.gnome.org/Attic/GPointingDeviceSettings"
SRC_URI="mirror://sourceforge.jp/gsynaptics/45812/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# recent enough x11-base/xorg-server required
RDEPEND="
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-2.14.0:2
	>=gnome-base/gconf-2.24:2
	>=gnome-base/gnome-settings-daemon-2.28
	>=x11-libs/libXi-1.2
	>=x11-libs/libX11-1.2.0
	!<=x11-base/xorg-server-1.6.0
	!gnome-extra/gsynaptics
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.35.5
"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-crash.patch" \
		"${FILESDIR}/${P}-plugin.patch" \
		"${FILESDIR}/${P}-reboot.patch" \
		"${FILESDIR}/${P}-gtk22.patch" \
		"${FILESDIR}/${P}-gsd-crash.patch" \
		"${FILESDIR}/${P}-gsd-3.2-fix.patch" \
		"${FILESDIR}/${P}-fix-build.patch"

	# Disable gsd plugin as it's incompatible since 3.8, bug #514672
	sed -i -e 's/ gnome-settings-daemon-plugins//' modules/Makefile.am || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}
