# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib systemd

DESCRIPTION="Open Source mobile telephony (GSM/UMTS) daemon"
HOMEPAGE="https://01.org/ofono"
SRC_URI="https://www.kernel.org/pub/linux/network/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 sparc x86"
IUSE="+atmodem bluetooth +cdmamodem +datafiles doc dundee examples +isimodem +phonesim +provision +qmimodem tools +udev upower"

REQUIRED_USE="dundee? ( bluetooth )"

RDEPEND=">=sys-apps/dbus-1.4
	>=dev-libs/glib-2.32
	net-misc/mobile-broadband-provider-info
	bluetooth? ( >=net-wireless/bluez-4.99 )
	udev? ( virtual/udev )
	examples? ( dev-python/dbus-python )
	tools? ( virtual/libusb:1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS )

src_configure() {
	econf \
		$(use_enable udev) \
		$(use_enable isimodem) \
		$(use_enable atmodem) \
		$(use_enable cdmamodem) \
		$(use_enable datafiles) \
		$(use_enable dundee) \
		$(use_enable bluetooth) \
		$(use_enable phonesim) \
		$(use_enable provision) \
		$(use_enable qmimodem) \
		$(use_enable tools) \
		$(use_enable examples test) \
		$(use_enable upower) \
		--disable-maintainer-mode \
		--disable-rilmodem
		--localstatedir=/var \
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default

	if use tools ; then
		dobin tools/auto-enable \
			tools/huawei-audio \
			tools/lookup-provider-name \
			tools/lookup-apn \
			tools/get-location \
			tools/tty-redirector
	fi

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use doc && dodoc doc/*.txt
}
