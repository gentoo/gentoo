# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="Microsoft Teams, an Office 365 multimedia collaboration client, pre-release"
HOMEPAGE="https://products.office.com/en-us/microsoft-teams/group-chat-software/"
SRC_URI="https://packages.microsoft.com/repos/ms-teams/pool/main/t/${PN}/${PN}_${PV}_amd64.deb"

LICENSE="ms-teams-pre"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror splitdebug test"
IUSE="swiftshader system-ffmpeg"

QA_PREBUILT="*"
# libasound2 (>= 1.0.16), libatk-bridge2.0-0 (>= 2.5.3), libatk1.0-0 (>= 2.2.0), libatspi2.0-0 (>= 2.9.90), libc6 (>= 2.17), libcairo2 (>= 1.10.0),
# libcups2 (>= 1.7.0), libdrm2 (>= 2.4.38), libexpat1 (>= 2.0.1), libgbm1 (>= 17.1.0~rc2), libgcc1 (>= 1:3.0), libgdk-pixbuf2.0-0 (>= 2.22.0),
# libglib2.0-0 (>= 2.39.4), libgtk-3-0 (>= 3.19.12), libnspr4 (>= 2:4.9-2~), libnss3 (>= 2:3.22), libpango-1.0-0 (>= 1.14.0), libpangocairo-1.0-0 (>= 1.14.0),
# libx11-6 (>= 2:1.4.99.1), libx11-xcb1, libxcb-dri3-0, libxcb1 (>= 1.6), libxcomposite1 (>= 1:0.3-1), libxcursor1 (>> 1.1.2), libxdamage1 (>= 1:1.1),
# libxext6, libxfixes3, libxi6 (>= 2:1.2.99.4), libxrandr2, libxrender1, libxtst6, apt-transport-https, libfontconfig1 (>= 2.11.0), libdbus-1-3 (>= 1.6.18),
# libstdc++6 (>= 4.8.1)
RDEPEND="
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		( app-accessibility/at-spi2-atk dev-libs/atk )
	)
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango
	system-ffmpeg? ( <media-video/ffmpeg-4.3[chromium] )
"

S="${WORKDIR}"

src_prepare() {
	default
	sed -i '/OnlyShowIn=/d' usr/share/applications/${PN}.desktop || die
	sed -e "s@^TEAMS_PATH=.*@TEAMS_PATH=${EPREFIX}/opt/${PN}/${PN}@" \
		-i usr/bin/${PN} || die
}

src_install() {
	rm -f _gpgorigin || die
	rm -r "usr/share/${PN}/resources/assets/"{.gitignore,macos,tlb,windows,x86,x64,arm64} || die
	rm -r "usr/share/${PN}/resources/tmp" || die
	rm "usr/share/${PN}/chrome-sandbox" || die

	insinto /opt
	doins -r usr/share/${PN}

	dobin usr/bin/${PN}
	domenu usr/share/applications/${PN}.desktop
	doicon usr/share/pixmaps/${PN}.png

	pushd "${ED}/opt/${PN}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	if use system-ffmpeg; then
		rm "${ED}/opt/${PN}/libffmpeg.so" || die
		dosym "../../usr/$(get_libdir)/chromium/libffmpeg.so" "opt/${PN}/libffmpeg.so" || die
		elog "Using system ffmpeg. This is experimental and may lead to crashes."
	fi

	if ! use swiftshader; then
		rm -r "${ED}/opt/${PN}/swiftshader" || die
		elog "Running without SwiftShader OpenGL implementation. If Teams doesn't start "
		elog "or you experience graphic issues, then try with USE=swiftshader enabled."
	fi

	fperms +x /usr/bin/${PN}
	fperms +x /opt/${PN}/${PN}
}
