# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info systemd toolchain-funcs udev

MY_PN='spacenav'
DESCRIPTION="The spacenavd daemon provides free alternative to the 3dxserv daemon"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="https://github.com/FreeSpacenav/spacenavd/releases/download/v${PV}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="X"

RDEPEND="X? (
		x11-apps/xdpyinfo
		x11-base/xorg-proto
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXtst
	)"
DEPEND="${RDEPEND}"

pkg_setup() {
	CONFIG_CHECK="~INPUT_EVDEV"
	ERROR_CFG="Your kernel needs INPUT_EVDEV for the spacenavd to work properly"
	check_extra_config
}

src_configure() {
	append-cflags -fcommon  # bug 708648
	econf \
		--disable-debug \
		--enable-hotplug \
		--disable-opt \
		$(use_enable X x11)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	# Config file
	insinto /etc
	newins "${S}/doc/example-spnavrc" spnavrc.sample
	newins "${S}/doc/spnavrc_smouse_ent" spnavrc-space-mouse-enterprise.sample
	newins "${S}/doc/spnavrc_spilot" spnavrc-space-pilot.sample

	# Init script
	newinitd "${FILESDIR}/spnavd" spacenavd
	systemd_dounit "${FILESDIR}/spacenavd.service"

	# Install udev rule but leave activiation to the user
	# since Xorg may be configured to grab the device already
	udev_newrules "${FILESDIR}"/99-space-navigator.rules-r2 99-space-navigator.rules.ignored

	# Daemon
	dobin "${S}/spacenavd"
	use X && dobin "${S}/spnavd_ctl"
}

pkg_postinst() {
	udev_reload

	elog "To start the Spacenav daemon system-wide by default"
	elog "you should add it to the default runlevel :"
	elog "\`rc-update add spacenavd default\` (for openRC)"
	elog "\`systemctl enable spacenavd\` (for systemd)"
	elog
	if use X; then
		elog "To start generating Spacenav X events by default"
		elog "you should add this command in your user startup"
		elog "scripts such as .gnomerc or .xinitrc :"
		elog "\`spnavd_ctl x11 start\`"
		elog
	fi
	elog "If you want to auto-start the daemon when you plug in"
	elog "a SpaceNavigator device, activate the related udev rule :"
	elog "\`sudo ln -s $(get_udevdir)/rules.d/99-space-navigator.rules.ignored /etc/udev/rules.d\`"
	ewarn "You must restart spnavd \`/etc/init.d/spacenavd restart\` to run"
	ewarn "the new version of the daemon or \`systemctl restart spacenavd\`"
	ewarn "if using systemd."
}

pkg_postrm() {
	udev_reload
}
