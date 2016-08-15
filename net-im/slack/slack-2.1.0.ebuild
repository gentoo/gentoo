# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit unpacker gnome2-utils

QA_PREBUILT="
	opt/slack/slack
	opt/slack/resources/app.asar.unpacked/node_modules/*
	opt/slack/libnode.so
	opt/slack/libgcrypt.so.11
	opt/slack/libffmpeg.so
	opt/slack/libCallsCore.so
"

DESCRIPTION="Team collaboration tool"
HOMEPAGE="http://www.slack.com/"

BASE_URI="https://downloads.slack-edge.com/linux_releases/${PN}-desktop-${PV}-_arch_.deb"

SRC_URI="
	x86? ( ${BASE_URI/_arch_/i386} )
	amd64? ( ${BASE_URI/_arch_/amd64} )
"

LICENSE="MIT Apache-2.0 BSD ISC LGPL-2 AFL-2.1 public-domain WTFPL-2 no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/cairo[xcb]
	media-libs/alsa-lib
	media-libs/harfbuzz[graphite]
	media-libs/libcanberra[gtk3]
	dev-libs/nss
	dev-libs/glib:2
	dev-libs/atk
	gnome-base/libgnome-keyring
	gnome-base/gconf:2
	sys-apps/dbus
	net-print/cups[ssl]
	net-misc/curl
	virtual/udev
	virtual/libc
	virtual/libffi
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

pkg_preinst() {
	gnome2_icon_savelist
}

src_install() {
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/${PN}.png

	newicon -s 512 usr/share/pixmaps/${PN}.png ${PN}.png
	domenu usr/share/applications/${PN}.desktop

	insinto /opt/${PN}
	doins -r usr/lib/${PN}/*
	fperms +x /opt/${PN}/${PN}
	dosym /opt/${PN}/${PN} /usr/bin/${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}
