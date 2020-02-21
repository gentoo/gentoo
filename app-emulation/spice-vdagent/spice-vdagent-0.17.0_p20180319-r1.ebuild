# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info

MY_P="${P/_*/}"
PATCHSET="${P/*_p/}"

DESCRIPTION="SPICE VD Linux Guest Agent"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/releases/${MY_P}.tar.bz2
	https://dev.gentoo.org/~tamiko/distfiles/${MY_P}-patches-${PATCHSET}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="consolekit selinux systemd"
S="${WORKDIR}/${MY_P}"

CDEPEND="
	>=app-emulation/spice-protocol-0.12.8
	media-libs/alsa-lib
	>=x11-libs/libpciaccess-0.10
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXinerama
	consolekit? ( sys-auth/consolekit sys-apps/dbus )
	systemd? ( sys-apps/systemd )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-vdagent )"

CONFIG_CHECK="~INPUT_UINPUT ~VIRTIO_CONSOLE"
ERROR_INPUT_UINPUT="User level input support (INPUT_UINPUT) is required"
ERROR_VIRTIO_CONSOLE="VirtIO console/serial device support (VIRTIO_CONSOLE) is required"

PATCHES=(
	"${WORKDIR}"/patches
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local opt=()
	if use consolekit; then
		opt+=( --with-session-info=console-kit )
	elif use systemd; then
		opt+=( --with-session-info=systemd )
	else
		opt+=( --with-session-info=none )
	fi

	econf \
		--with-init-script=systemd \
		--localstatedir="${EPREFIX}"/var \
		"${opt[@]}"
}

src_install() {
	default

	cd "${ED}" && rmdir -p var/run/spice-vdagentd || die

	keepdir /var/log/spice-vdagentd

	newinitd "${FILESDIR}/${PN}.initd-3" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-2" "${PN}"
}
