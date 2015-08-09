# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="Unofficial tool for controlling the Razer Copperhead mouse"
HOMEPAGE="http://razertool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="virtual/libusb:0
	gtk? (
		>=gnome-base/librsvg-2.0
		>=x11-libs/cairo-1.0.0
		>=x11-libs/gtk+-2.8.0:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i razertool.rules.example \
		-e 's:ACTION=="add", ::;s:BUS=:SUBSYSTEMS=:;s:SYSFS{:ATTRS{:g' \
		|| die "sed razertool.rules.example action failed"

	# plugdev group may not exist (created by hal), default to usb
	sed -i razertool.rules.example \
		-e 's:plugdev:usb:' \
		|| die "sed razertool.rules.example plugdev failed"
}

src_configure() {
	econf $(use_enable gtk)
}

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /lib/udev/rules.d
	newins razertool.rules.example 90-razertool.rules || die

	dodoc AUTHORS ChangeLog NEWS README

	# Icon and desktop entry
	dosym /usr/share/${PN}/pixmaps/${PN}-icon.png /usr/share/pixmaps/${PN}-icon.png
	make_desktop_entry "razertool-gtk" "RazerTool" ${PN}-icon "GTK;Settings;HardwareSettings"
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
