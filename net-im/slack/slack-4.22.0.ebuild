# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_64 )

inherit desktop multilib-build optfeature pax-utils unpacker xdg

DESCRIPTION="Team collaboration tool"
HOMEPAGE="https://www.slack.com"
SRC_URI="https://downloads.slack-edge.com/releases/linux/${PV}/prod/x64/${PN}-desktop-${PV}-amd64.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="appindicator suid"
RESTRICT="bindist mirror"

RDEPEND="app-accessibility/at-spi2-atk:2[${MULTILIB_USEDEP}]
	app-accessibility/at-spi2-core:2[${MULTILIB_USEDEP}]
	dev-libs/atk:0[${MULTILIB_USEDEP}]
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	media-libs/mesa:0[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libdrm:0[${MULTILIB_USEDEP}]
	x11-libs/libX11:0[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0/1.12[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:0[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:0[${MULTILIB_USEDEP}]
	x11-libs/libXext:0[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:0[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon:0[${MULTILIB_USEDEP}]
	x11-libs/libxkbfile:0[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]
	appindicator? ( dev-libs/libappindicator:3[${MULTILIB_USEDEP}] )"

QA_PREBUILT="/opt/slack/chrome-sandbox
	/opt/slack/libEGL.so
	/opt/slack/libffmpeg.so
	/opt/slack/libGLESv2.so
	/opt/slack/libvk_swiftshader.so
	/opt/slack/libvulkan.so*
	/opt/slack/resources/app.asar.unpacked/node_modules/*
	/opt/slack/slack
	/opt/slack/swiftshader/libEGL.so
	/opt/slack/swiftshader/libGLESv2.so"

S="${WORKDIR}"

src_prepare() {
	default

	# remove hardcoded path, logging noise (wrt 694058, 711494)
	sed -i  -e '/Icon/s|/usr/share/pixmaps/slack.png|slack|' \
		-e '/Exec/s|slack|slack -s|' \
		usr/share/applications/slack.desktop \
		|| die "sed failed in Icon for slack.desktop"

	if use appindicator ; then
		sed -i '/Exec/s|=|=env XDG_CURRENT_DESKTOP=Unity |' \
			usr/share/applications/slack.desktop \
			|| die "sed failed for slack.desktop"
	fi

	rm usr/lib/slack/LICENSE{,S-linux.json} \
		|| die "rm licenses failed"
}

src_install() {
	doicon usr/share/pixmaps/slack.png
	doicon -s 512 usr/share/pixmaps/slack.png
	domenu usr/share/applications/slack.desktop

	insinto /opt # wrt 720134
	cp -a usr/lib/slack "${ED}"/opt || die "cp failed"

	use suid && fperms u+s /opt/slack/chrome-sandbox # wrt 713094
	dosym ../../opt/slack/slack usr/bin/slack

	pax-mark -m "${ED}"/opt/slack/slack
}

pkg_postinst() {
	optfeature "storing passwords via gnome-keyring" app-crypt/libsecret

	xdg_pkg_postinst
}
