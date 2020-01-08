# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin/}"
MULTILIB_COMPAT=( abi_x86_64 )

inherit desktop gnome2-utils multilib-build pax-utils unpacker xdg-utils

DESCRIPTION="Team collaboration tool"
HOMEPAGE="http://www.slack.com/"
SRC_URI="https://downloads.slack-edge.com/linux_releases/${MY_PN}-desktop-${PV}-amd64.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="ayatana gnome-keyring pax_kernel"
RESTRICT="bindist mirror"

RDEPEND="dev-libs/atk:0[${MULTILIB_USEDEP}]
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	gnome-base/gconf:2[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	net-misc/curl:0[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]
	x11-libs/libX11:0[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0/1.12[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:0[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:0[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:0[${MULTILIB_USEDEP}]
	x11-libs/libXext:0[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:0[${MULTILIB_USEDEP}]
	x11-libs/libXi:0[${MULTILIB_USEDEP}]
	x11-libs/libxkbfile:0[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:0[${MULTILIB_USEDEP}]
	x11-libs/libXrender:0[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver:0[${MULTILIB_USEDEP}]
	x11-libs/libXtst:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]
	ayatana? ( dev-libs/libappindicator:2[${MULTILIB_USEDEP}] )
	gnome-keyring? ( app-crypt/libsecret:0[${MULTILIB_USEDEP}] )"

QA_PREBUILT="opt/slack/slack
	opt/slack/resources/app.asar.unpacked/node_modules/*
	opt/slack/libnode.so
	opt/slack/libffmpeg.so
	opt/slack/libCallsCore.so"

S="${WORKDIR}"

src_prepare() {
	default

	if use ayatana ; then
		sed -i '/Exec/s|=|=env XDG_CURRENT_DESKTOP=Unity |' \
			usr/share/applications/slack.desktop \
			|| die "sed failed for slack.desktop"
	fi
}

src_install() {
	doicon usr/share/pixmaps/slack.png
	doicon -s 512 usr/share/pixmaps/slack.png
	domenu usr/share/applications/slack.desktop

	insinto /opt/slack
	doins -r usr/lib/slack/.
	fperms +x /opt/slack/slack
	dosym ../../opt/slack/slack usr/bin/slack

	use pax_kernel && pax-mark -m "${ED%/}"/opt/slack/slack
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
