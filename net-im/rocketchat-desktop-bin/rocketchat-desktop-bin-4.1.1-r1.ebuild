# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop rpm xdg

DESCRIPTION="The Ultimate Open Source Web Chat Platform"
HOMEPAGE="https://rocket.chat"
SRC_URI="https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${PV}/rocketchat-${PV}-linux-x86_64.rpm"
S="${WORKDIR}"

KEYWORDS="-* ~amd64"
# Electron bundles a bunch of things
LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL-1.1 CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
RESTRICT="bindist mirror"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libayatana-appindicator
	dev-libs/nspr
	dev-libs/nss
	media-fonts/noto-emoji
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-libs/glibc
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

QA_PREBUILT="opt/Rocket.Chat/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "opt/Rocket.Chat/locales" || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

src_install() {
	for size in {16,32,48,64,128,256,512,1024}; do
		doicon -s ${size} "usr/share/icons/hicolor/${size}x${size}/apps/rocketchat-desktop.png"
	done

	domenu usr/share/applications/rocketchat-desktop.desktop

	local DESTDIR="/opt/Rocket.Chat"

	# https://github.com/RocketChat/Rocket.Chat.Electron/issues/2536
	dosym ../../usr/lib64/libayatana-appindicator3.so "${DESTDIR}"/libappindicator3.so

	pushd "opt/Rocket.Chat" || die

	exeinto "${DESTDIR}"
	doexe chrome-sandbox rocketchat-desktop *.so*

	insinto "${DESTDIR}"
	doins *.pak *.bin *.json *.dat
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fperms 4755 "${DESTDIR}"/chrome-sandbox

	dosym "${DESTDIR}"/rocketchat-desktop /opt/bin/rocketchat-desktop
	popd || die
}
