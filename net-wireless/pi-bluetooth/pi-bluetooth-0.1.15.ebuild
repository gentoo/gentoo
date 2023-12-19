# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev systemd

DESCRIPTION="Init scripts for bluetooth on Raspberry Pi Zero W, 3 and 4"
HOMEPAGE="https://github.com/RPi-Distro/pi-bluetooth
	https://archive.raspberrypi.org/debian/pool/main/p/pi-bluetooth/"
BLUEZ_P=bluez-5.55
BLUEZ_S=${WORKDIR}/${BLUEZ_P}
SRC_URI="https://archive.raspberrypi.org/debian/pool/main/p/${PN}/${PN}_${PV}.tar.xz
	https://www.kernel.org/pub/linux/bluetooth/${BLUEZ_P}.tar.xz"
S="${WORKDIR}/${PN}"
LICENSE="BSD GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE="systemd"
RDEPEND="sys-apps/raspberrypi-sys-mods
	sys-firmware/raspberrypi-bluetooth-ucode
	net-wireless/bluez[deprecated,udev]"
DEPEND=""
BDEPEND=""
DOCS="debian/changelog"
PATCHES=(
	"${FILESDIR}"/${P}-001-change-service-unit-type-to-oneshot.patch
	"${FILESDIR}"/${P}-002-Integrated-UART-bluetooth-adapter-not-working-after-restart-if-another.patch
	)

src_prepare() {
	default

	ebegin "Sed'ing path for hciconfig in bthelper"
	if grep -q -E "(^| )/bin/hciconfig" usr/bin/bthelper; then
		sed -i -E \
			-e 's:(^| )/bin/hciconfig:\1/usr/bin/hciconfig:' \
			usr/bin/bthelper || die "Sed of bthelper for hciconfig path failed"
		eend
	else
		eend 1
		eerror "usr/bin/bthelper no longer needs its path for /bin/hciconfig corrected"
		die "Please remove workaround sed from ${PF} ebuild"
	fi

	ebegin "Sed'ing /usr/bin/hciattach -> /usr/lib/pi-bluetooth/rpi-hciattach"
	if grep -q -E "^HCIATTACH=/usr/bin/hciattach$" usr/bin/btuart; then
		sed -i -E \
			-e 's:^HCIATTACH=/usr/bin/hciattach$:HCIATTACH=/usr/lib/pi-bluetooth/rpi-hciattach:' \
			usr/bin/btuart || die "Sed of btuart hciattach -> rpi-hciattach failed"
		eend
	else
		eend 1
		eerror 'usr/bin/btuart has changed, ^HCIATTACH=/usr/bin/hciattach$ no longer matches'
		die "Check what's changed and why"
	fi

	if ! use systemd; then
		# bluetoothctl needs the bluez daemon running to work.
		# udev may run before the bluez daemon, so we remove the bluetoothctl power-cycle
		# since it's not essential
		ebegin "Sed'ing to remove bluetoothctl from bthelper on non-systemd systems."
		if grep -q '# Force reinitialisation to allow extra features such as Secure Simple Pairing' usr/bin/bthelper; then
			sed -i \
				-e '/# Force reinitialisation to allow extra features such as Secure Simple Pairing/,+3d' \
				usr/bin/bthelper || die "Failed sed'ing to remove bluetoothctl"
			eend
		else
			eend 1
			eerror 'usr/bin/bthelper no longer contains grep pattern "# Force reinitialisation(...)"'
			die "Check what's wrong in ${PF} ebuild"
		fi
	fi

	# We have to build our own hciattach since some changes that aren't
	# generalizable have been applied to upstream bluez to make it work better
	# with the Raspberry Pi.
	# Specifically:
	# * hciattach will by default load firmware from /etc/firmware, not
	#   /lib/firmware. /etc/firmware is a... bad choice... for a firmware
	#   dir
	# * The UART speed must be reset *after* the firmware download, or risk
	#   firmware not being loaded
	# * sleep(1) to avoid race condition
	# Changing the firmware dir, we should be able to get into Gentoo,
	# but the rest of it is just due to quirky behaviour of the various
	# Raspberry Pi boards.
	cd "${BLUEZ_S}"
	eapply -p1 "${FILESDIR}"/${PN}-0.1.15-003-hciattach-raspberrypi-mods.patch
}

src_configure() {
	cd "${BLUEZ_S}"
	econf	--localstatedir=/var \
		--disable-android \
		--enable-datafiles \
		--enable-optimization \
		--disable-debug \
		--enable-pie \
		--enable-threads \
		--enable-library \
		--enable-tools \
		--enable-manpages \
		--enable-monitor \
		--disable-btpclient \
		--disable-external-ell \
		--disable-cups \
		--enable-deprecated \
		--enable-experimental \
		--disable-mesh \
		--disable-external-ell \
		--disable-midi \
		--disable-obex \
		--enable-client \
		--disable-systemd \
		--disable-test \
		--enable-udev \
		--enable-hid2hci \
		--enable-sixaxis
}

src_compile() {
	cd "${BLUEZ_S}"
	emake tools/hciattach
}

src_install() {
	default
	dobin usr/bin/btuart
	dobin usr/bin/bthelper
	exeinto /usr/lib/${PN}
	newexe "${BLUEZ_S}/tools/hciattach" rpi-hciattach
	if use systemd; then
		udev_dorules lib/udev/rules.d/90-pi-bluetooth.rules
		for service in {bthelper@,hciuart}.service; do
			systemd_newunit debian/${PN}.${service} ${service}
		done
	else
		newinitd "${FILESDIR}"/init.d_rpi-hciuart-1 hciuart
		udev_dorules "${FILESDIR}"/95-pi-bthelper.rules
	fi
}

pkg_postinst() {
	elog "To enable the Bluetooth module of your Raspberry Pi, do:"
	if use systemd; then
		elog "systemctl enable hciuart"
	else
		elog "rc-update add bluetooth default"
		elog "rc-update add hciuart default"
	fi
	elog "and reboot"
}
