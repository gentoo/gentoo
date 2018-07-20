# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin/}"
BASE_URI="https://downloads.slack-edge.com/linux_releases/${MY_PN}-desktop-${PV}-_arch_.deb"

inherit eutils gnome2-utils unpacker xdg-utils

DESCRIPTION="Team collaboration tool"
HOMEPAGE="http://www.slack.com/"
SRC_URI="x86? ( ${BASE_URI/_arch_/i386} )
	amd64? ( ${BASE_URI/_arch_/amd64} )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror"

RDEPEND="dev-libs/atk:0
	dev-libs/expat:0
	dev-libs/glib:2
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	gnome-base/libgnome-keyring:0
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-misc/curl:0
	net-print/cups:0
	sys-apps/dbus:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11:0
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXi:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXScrnSaver:0
	x11-libs/libXtst:0
	x11-libs/pango:0"

QA_PREBUILT="opt/slack/slack
	opt/slack/resources/app.asar.unpacked/node_modules/*
	opt/slack/libnode.so
	opt/slack/libffmpeg.so
	opt/slack/libCallsCore.so"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/${MY_PN}.png

	newicon -s 512 usr/share/pixmaps/${MY_PN}.png ${MY_PN}.png
	domenu usr/share/applications/${MY_PN}.desktop

	insinto /opt/${MY_PN}
	doins -r usr/lib/${MY_PN}/.
	fperms +x /opt/${MY_PN}/${MY_PN}
	dosym ../../opt/${MY_PN}/${MY_PN} usr/bin/${MY_PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
