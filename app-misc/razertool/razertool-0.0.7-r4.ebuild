# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop

DESCRIPTION="Unofficial tool for controlling the Razer Copperhead mouse"
HOMEPAGE="http://razertool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="dev-libs/glib:2
	virtual/libusb:0
	gtk? (
		dev-libs/atk
		>=gnome-base/librsvg-2.0
		>=x11-libs/cairo-1.0.0
		x11-libs/gdk-pixbuf
		>=x11-libs/gtk+-2.8.0:2
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=( "${FILESDIR}"/${P}-ar.patch )

src_prepare() {
	default

	sed -i razertool.rules.example \
		-e 's:ACTION=="add", ::;s:BUS=:SUBSYSTEMS=:;s:SYSFS{:ATTRS{:g' \
		|| die

	# plugdev group may not exist (created by hal), default to usb
	sed -i razertool.rules.example \
		-e 's:plugdev:usb:' \
		|| die

	eautoreconf
}

src_configure() {
	econf $(use_enable gtk)
}

src_install() {
	default

	insinto /lib/udev/rules.d
	newins razertool.rules.example 90-razertool.rules

	# Icon and desktop entry
	if use gtk; then
		dosym ../razertool/pixmaps/razertool-icon.png /usr/share/pixmaps/razertool-icon.png
		make_desktop_entry "razertool-gtk" "RazerTool" ${PN}-icon "GTK;Settings;HardwareSettings"
	fi
}

pkg_postinst() {
	elog "Razer Copperhead mice need firmware version 6.20 or higher"
	elog "to work properly. Running ${PN} on mice with older firmwares"
	elog "might lead to random USB-disconnects."
	elog "To run as non-root, add yourself to the usb group:"
	elog "   gpasswd -a <user> usb"
	elog "or adapt permissions/owner/group in:"
	elog "   /etc/udev/rules.d/90-razertool.rules"
	elog "Then unplug and plug in the mouse."
}
