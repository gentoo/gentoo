# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info

DESCRIPTION="SPICE VD Linux Guest Agent"
HOMEPAGE="http://spice-space.org/"
SRC_URI="http://spice-space.org/download/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+consolekit selinux systemd"

CDEPEND="media-libs/alsa-lib
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXinerama
	>=x11-libs/libpciaccess-0.10
	>=app-emulation/spice-protocol-0.12.8
	consolekit? ( sys-auth/consolekit sys-apps/dbus )
	systemd? ( sys-apps/systemd )"
DEPEND="virtual/pkgconfig
	${CDEPEND}"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-vdagent )"

CONFIG_CHECK="~INPUT_UINPUT ~VIRTIO_CONSOLE"
ERROR_INPUT_UINPUT="User level input support is required"
ERROR_VIRTIO_CONSOLE="VirtIO console/serial device support is required"

src_configure() {
	local opt="--with-session-info=none --with-init-script=systemd"

	use systemd && opt="--with-session-info=systemd"
	use consolekit && opt="${opt} --with-session-info=console-kit"

	econf \
		--localstatedir=/var \
		${opt}
}

src_install() {
	default

	rm -rf "${D}"/etc/{rc,tmpfiles}.d

	keepdir /var/log/spice-vdagentd

	newinitd "${FILESDIR}/${PN}.initd-2" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-2" "${PN}"
}
