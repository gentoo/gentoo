# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="SPICE VD Linux Guest Agent"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk selinux systemd"

CDEPEND="
	dev-libs/glib:2
	>=app-emulation/spice-protocol-0.14.0
	media-libs/alsa-lib
	>=x11-libs/libpciaccess-0.10
	x11-libs/libdrm
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXinerama
	gtk? ( x11-libs/gtk+:3 )
	systemd? ( sys-apps/systemd )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-vdagent )"

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

	cd "${ED}" && rmdir -p var/run/spice-vdagentd || die

	keepdir /var/log/spice-vdagentd

	newinitd "${FILESDIR}/${PN}.initd-4" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-2" "${PN}"
}
