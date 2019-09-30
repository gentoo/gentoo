# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop gnome2-utils systemd xdg-utils

DESCRIPTION="Feature rich multi-platform remote desktop application"
HOMEPAGE="https://anydesk.com"
SRC_URI="amd64? ( https://download.anydesk.com/linux/${P}-amd64.tar.gz )
	x86? ( https://download.anydesk.com/linux/${P}-i686.tar.gz )"

# OpeSSL/SSLeay, libvpx, zlib, Xiph, xxHash
LICENSE="AnyDesk-TOS BSD BSD-2 openssl ZLIB"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	dev-libs/atk
	dev-libs/glib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/glu
	media-libs/mesa[X(+)]
	sys-auth/polkit
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/gtkglext
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/pango
	x11-libs/pangox-compat
"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/${PN}/*"

src_install() {
	local dst="/opt/${PN}"

	dodir ${dst}
	exeinto ${dst}
	doexe ${PN}

	dodir /opt/bin
	dosym ${dst}/${PN} /opt/bin/${PN}

	newinitd "${FILESDIR}"/anydesk.init anydesk
	systemd_newunit "${FILESDIR}"/anydesk-4.0.1.service anydesk.service

	insinto /usr/share/polkit-1/actions
	doins polkit-1/com.philandro.anydesk.policy

	insinto /usr/share
	doins -r icons

	domenu anydesk.desktop

	keepdir /etc/${PN}

	dodoc changelog copyright README
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

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
		elog "AnyDesk might require the following commands/packages"
		elog "for some functions:"
		elog "* lsb_release	(sys-apps/lsb-release)"
		elog "* lsusb		(sys-apps/usbutils)"
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
