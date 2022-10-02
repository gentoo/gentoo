# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

inherit chromium-2 desktop pax-utils readme.gentoo-r1 unpacker xdg-utils

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="https://chromium.org/"

MY_P=${P}-1

SRC_URI="https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-common.tar.xz
	https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-l10n.tar.xz
	amd64? (
		https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-common-x86_64.tar.xz
		wayland? ( https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-wayland-x86_64.tar.xz )
		!wayland? ( https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-x11-x86_64.tar.xz )
	)
	arm64? (
		https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-common-aarch64.tar.xz
		wayland? ( https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-wayland-aarch64.tar.xz )
		!wayland? ( https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-x11-aarch64.tar.xz )
	)
	x86? (
		https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-common-i686.tar.xz
		wayland? ( https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-wayland-i686.tar.xz )
		!wayland? ( https://dev.gentoo.org/~sultan/distfiles/www-client/chromium-bin/${MY_P}-x11-i686.tar.xz )
	)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 arm64 ~x86"
IUSE="cpu_flags_x86_sse2 suid wayland widevine"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/nspr
	>=dev-libs/nss-3.26
	media-libs/alsa-lib
	|| (
		media-libs/flac:0/0
		media-libs/flac-compat:8.3.0
	)
	media-libs/fontconfig
	>=media-libs/freetype-2.11.0-r1
	media-libs/libjpeg-turbo
	media-libs/libwebp
	media-libs/mesa[gbm(+)]
	media-libs/openh264:0/6.1
	net-misc/curl[ssl]
	net-print/cups
	sys-apps/dbus
	sys-apps/pciutils
	>=sys-devel/gcc-9.3.0
	>=sys-libs/glibc-2.32
	sys-libs/zlib[minizip]
	virtual/ttf-fonts
	virtual/udev
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf:2
	|| (
		x11-libs/gtk+:3[X,wayland?]
		gui-libs/gtk:4[X,wayland?]
	)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	x11-misc/xdg-utils
	amd64? (
		widevine? ( www-plugins/chrome-binary-plugins )
	)
	wayland? ( dev-libs/wayland )
"

S=${WORKDIR}
QA_PREBUILT="*"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/noto
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

To fix broken icons on the Downloads page, you should install an icon
theme that covers the appropriate MIME types, and configure this as your
GTK+ icon theme.

For native file dialogs in KDE, install kde-apps/kdialog.

To make password storage work with your desktop environment you may
have install one of the supported credentials management applications:
- app-crypt/libsecret (GNOME)
- kde-frameworks/kwallet (KDE)
If you have one of above packages installed, but don't want to use
them in Chromium, then add --password-store=basic to CHROMIUM_BIN_FLAGS
in /etc/chromium-bin/default.
"

pkg_pretend() {
	if use amd64 || use x86; then
		if ! use cpu_flags_x86_sse2; then
			eerror "This package requires a CPU supporting the SSE2 instruction set."
			die "SSE2 support missing"
		fi
	fi
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config

	if ! use amd64 && use widevine; then
		ewarn "Widevine CDM plugin is not available for your architecture."
	fi
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	local CHROMIUM_BIN_HOME="opt/chromium-bin"

	if ! use suid; then
		rm "${CHROMIUM_BIN_HOME}/chrome-sandbox" || die
	fi

	# Clean unneeded languages
	pushd "${CHROMIUM_BIN_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# Install icons
	local size
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${CHROMIUM_BIN_HOME}/icons/hicolor/${size}x${size}/apps/chromium-browser.png" ${PN}-browser.png
	done
	rm -r "${CHROMIUM_BIN_HOME}/icons"

	# Allow users to override command-line options, bug #357629.
	insinto /etc/chromium-bin
	newins "${FILESDIR}/chromium-bin.default" "default"

	# Install desktop entry
	domenu "${FILESDIR}/chromium-bin-browser-chromium.desktop"

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	newins "${FILESDIR}/chromium-bin-browser.xml" chromium-bin-browser.xml

	# Install manpage; bug #684550
	doman "${FILESDIR}/chromium-bin-browser.1"
	dosym chromium-bin-browser.1 /usr/share/man/man1/chromium-bin.1

	pax-mark m "${CHROMIUM_BIN_HOME}/chrome"

	# Symlink Widevine CDM
	if use widevine; then
		dosym "../../usr/$(get_libdir)/chromium-browser/WidevineCdm" "${CHROMIUM_BIN_HOME}/WidevineCdm"
	fi

	# Install launcher
	exeinto "${CHROMIUM_BIN_HOME}"
	doexe "${FILESDIR}/chromium-bin-launcher.sh"

	# It is important that we name the target "chromium-bin-browser",
	# xdg-utils expect it; bug #355517.
	dosym "../../${CHROMIUM_BIN_HOME}/chromium-bin-launcher.sh" /usr/bin/chromium-bin-browser
	# keep the old symlink around for consistency
	dosym "../../${CHROMIUM_BIN_HOME}/chromium-bin-launcher.sh" /usr/bin/chromium-bin

	dosym "../../${CHROMIUM_BIN_HOME}/chromedriver" /usr/bin/chromedriver-bin

	readme.gentoo_create_doc
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog

	elog "For VA-API support you need to install x11-libs/libva with"
	elog "USE=X enabled."
	elog
	elog "VA-API is disabled by default at runtime. You have to enable it"
	elog "by adding --enable-features=VaapiVideoDecoder to CHROMIUM_BIN_FLAGS"
	elog "in /etc/chromium-bin/default."

	if use wayland; then
		elog
		elog "For screencast support you need to install media-video/pipewire."
		elog
		elog "Screencast is disabled by default at runtime. Either enable it"
		elog "by navigating to chrome://flags/#enable-webrtc-pipewire-capturer"
		elog "inside Chromium or add --enable-features=WebRTCPipeWireCapturer"
		elog "to CHROMIUM_BIN_FLAGS in /etc/chromium-bin/default."
	fi

	elog
	elog "chromium-bin profile defaults to \${HOME}/.config/chromium-bin."
	elog "Some extensions (e.g. KeepassXC) expect default chromium profile"
	elog "at \${HOME}/.config/chromium. You can overwrite this by adding"
	elog "--user-data-dir=\${HOME}/.config/chromium to CHROMIUM_BIN_FLAGS"
	elog "in /etc/chromium-bin/default."
}
