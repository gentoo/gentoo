# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info tmpfiles udev

DESCRIPTION="SPICE VD Linux Guest Agent"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong x86"
IUSE="gtk selinux systemd"

COMMON_DEPEND="
	dev-libs/glib:2
	>=app-emulation/spice-protocol-0.14.0
	media-libs/alsa-lib
	sys-apps/dbus
	x11-libs/libdrm
	>=x11-libs/libpciaccess-0.10
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXinerama
	gtk? ( x11-libs/gtk+:3 )
	systemd? ( sys-apps/systemd )"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-vdagent )"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~INPUT_UINPUT ~VIRTIO_CONSOLE"
ERROR_INPUT_UINPUT="User level input support (INPUT_UINPUT) is required"
ERROR_VIRTIO_CONSOLE="VirtIO console/serial device support (VIRTIO_CONSOLE) is required"

src_configure() {
	local opt=()
	if use systemd; then
		opt+=( --with-session-info=systemd )
	else
		opt+=( --with-session-info=none )
	fi

	econf \
		--with-init-script=systemd \
		--localstatedir="${EPREFIX}"/var \
		$(use_with gtk) \
		"${opt[@]}"
}

src_install() {
	default

	rmdir "${ED}"/var/run/spice-vdagentd || die

	keepdir /var/log/spice-vdagentd

	newinitd "${FILESDIR}/${PN}.initd-4" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-2" "${PN}"
}

pkg_postinst() {
	udev_reload
	tmpfiles_process spice-vdagentd.conf
}

pkg_postrm() {
	udev_reload
}
