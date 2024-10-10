# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop optfeature systemd xdg-utils

DESCRIPTION="Feature rich multi-platform remote desktop application"
HOMEPAGE="https://anydesk.com"
SRC_URI="https://download.anydesk.com/linux/${P}-amd64.tar.gz"

# OpeSSL/SSLeay, libvpx, zlib, Xiph, xxHash
LICENSE="AnyDesk-TOS BSD BSD-2 openssl ZLIB"
SLOT="0"
KEYWORDS="-* ~amd64"

# x11-libs/gtkglext is required and cannot be mitigated: https://bugs.gentoo.org/868255
RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/glib:2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/glu
	media-libs/libglvnd
	sys-auth/polkit
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/gtkglext
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
"
BDEPEND="dev-util/patchelf"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/${PN}/*"

src_install() {
	local dst="/opt/${PN}"

	exeinto ${dst}
	doexe ${PN}

	dodir /opt/bin
	dosym "${dst}/${PN}" "/opt/bin/${PN}"

	newinitd "${FILESDIR}/anydesk.init" anydesk
	systemd_newunit "${FILESDIR}/anydesk-4.0.1.service" anydesk.service

	insinto /usr/share/polkit-1/actions
	doins polkit-1/com.anydesk.anydesk.policy

	insinto /usr/share
	doins -r icons

	domenu "${FILESDIR}/anydesk.desktop"

	dodoc copyright README
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To run AnyDesk as background service use:"
		elog
		elog "OpenRC:"
		elog "# rc-service anydesk start"
		elog "# rc-update add anydesk default"
		elog
		elog "Systemd:"
		elog "# systemctl start anydesk.service"
		elog "# systemctl enable anydesk.service"
		elog
		elog "Please see README at /usr/share/doc/${PF}/README.bz2 for"
		elog "further information about the linux version of AnyDesk."
		elog
	fi

	optfeature_header "AnyDesk additional tools:"
	optfeature "lsb_release" sys-apps/lsb-release
	optfeature "lspci" sys-apps/pciutils
	optfeature "lsusb" sys-apps/usbutils
	optfeature "sound support" media-libs/libcanberra[gtk2]
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
