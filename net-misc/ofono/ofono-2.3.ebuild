# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Open Source mobile telephony (GSM/UMTS) daemon"
HOMEPAGE="https://git.kernel.org/pub/scm/network/ofono/ofono.git"
SRC_URI="https://mirrors.edge.kernel.org/pub/linux/network/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+atmodem bluetooth +datafiles doc dundee examples +isimodem +phonesim +provision +qmimodem tools +udev upower"

REQUIRED_USE="dundee? ( bluetooth )"

RDEPEND=">=sys-apps/dbus-1.6
	>=dev-libs/glib-2.68
	net-misc/mobile-broadband-provider-info
	bluetooth? ( >=net-wireless/bluez-4.99 )
	udev? ( virtual/udev )
	examples? ( dev-python/dbus-python )
	tools? ( virtual/libusb:1 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS )

src_configure() {
	econf \
		$(use_enable udev) \
		$(use_enable isimodem) \
		$(use_enable atmodem) \
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
		--disable-rilmodem \
		--localstatedir=/var \
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default

	if use tools ; then
		dobin tools/auto-enable \
			tools/huawei-audio \
			tools/lookup-apn \
			tools/get-location \
			tools/tty-redirector
	fi

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use doc && dodoc doc/*.txt
}
