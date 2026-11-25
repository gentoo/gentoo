# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB en-US es-419 es et fa fil fi
	fr gu he hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro
	ru sk sl sr sv sw ta te th tr uk ur vi zh-CN zh-TW"
MULTILIB_COMPAT=( abi_x86_64 )

inherit chromium-2 desktop multilib-build optfeature pax-utils unpacker xdg

DESCRIPTION="Team collaboration tool"
HOMEPAGE="https://slack.com"
SRC_URI="https://downloads.slack-edge.com/desktop-releases/linux/x64/${PV}/${PN}-desktop-${PV}-amd64.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="appindicator +seccomp suid wayland"
RESTRICT="bindist mirror splitdebug"

RDEPEND="app-accessibility/at-spi2-core:2[${MULTILIB_USEDEP}]
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
	appindicator? ( dev-libs/libayatana-appindicator )
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )"

QA_PREBUILT="opt/slack/chrome-sandbox
	opt/slack/chrome_crashpad_handler
	opt/slack/libffmpeg.so
	opt/slack/libvk_swiftshader.so
	opt/slack/libvulkan.so.1
	opt/slack/resources/app.asar.unpacked/node_modules/*
	opt/slack/slack"

pkg_pretend() {
	use suid || chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	pushd usr/lib/slack/locales || die "pushd failed"
	chromium_remove_language_paks
	popd || die "popd failed"

	# remove hardcoded path, logging noise (wrt 694058, 711494)
	sed -i  -e '/Icon/s|/usr/share/pixmaps/slack.png|slack|' \
		-e '/Exec/s|slack|slack -s|' \
		usr/share/applications/slack.desktop \
		|| die "sed failed in Icon for slack.desktop"

	rm usr/lib/slack/LICENSE{,S-linux.json} \
		usr/lib/slack/resources/LICENSES.chromium.html \
		|| die "rm licenses failed"

	if use appindicator ; then
		sed -i '/Exec/s|=|=env XDG_CURRENT_DESKTOP=Unity |' \
			usr/share/applications/slack.desktop \
			|| die "sed failed for appindicator"
	fi

	if ! use suid ; then
		rm usr/lib/slack/chrome-sandbox || die "rm failed"
	fi

	if ! use seccomp ; then
		sed -i '/Exec/s/%U/%U --disable-seccomp-filter-sandbox/' \
			usr/share/applications/slack.desktop \
			|| die "sed failed for seccomp"
	fi
}

src_install() {
	doicon usr/share/pixmaps/slack.png
	doicon -s 512 usr/share/pixmaps/slack.png
	domenu usr/share/applications/slack.desktop

	insinto /opt # wrt 720134
	cp -a usr/lib/slack "${ED}"/opt || die "cp failed"

	use suid && fperms u+s /opt/slack/chrome-sandbox # wrt 713094

	dosym ../../opt/slack/slack usr/bin/slack
	use appindicator && dosym ../../usr/lib64/libayatana-appindicator3.so \
		/opt/slack/libappindicator3.so

	pax-mark -m "${ED}"/opt/slack/slack
}

pkg_postinst() {
	optfeature "storing passwords via Secret Service API provider" virtual/secret-service
	xdg_pkg_postinst
}
