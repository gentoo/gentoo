# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin/}"
MY_PV="${PV/-r*/}"

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop linux-info optfeature unpacker xdg

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com"
SRC_URI="https://dl.discordapp.net/apps/linux/${MY_PV}/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip test"
IUSE="+seccomp system-ffmpeg"

RDEPEND="
		|| (
			>=app-accessibility/at-spi2-core-2.46.0:2
			( app-accessibility/at-spi2-atk dev-libs/atk )
		)
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
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
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	system-ffmpeg? ( media-video/ffmpeg[chromium] )
"

DESTDIR="/opt/${MY_PN}"

QA_PREBUILT="
	${DESTDIR#/}/${MY_PN^}
	${DESTDIR#/}/chrome-sandbox
	${DESTDIR#/}/libffmpeg.so
	${DESTDIR#/}/libvk_swiftshader.so
	${DESTDIR#/}/libvulkan.so
	${DESTDIR#/}/libEGL.so
	${DESTDIR#/}/libGLESv2.so
	${DESTDIR#/}/libVkICD_mock_icd.so
	${DESTDIR#/}/swiftshader/libEGL.so
	${DESTDIR#/}/swiftshader/libGLESv2.so
	${DESTDIR#/}/swiftshader/libvk_swiftshader.so
"

CONFIG_CHECK="~USER_NS"

S="${WORKDIR}/${MY_PN^}"

src_unpack() {
	unpack ${MY_PN}-${MY_PV}.tar.gz
}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# remove post-install script
	rm postinst.sh || die "the removal of the unneeded post-install script failed"
	# cleanup languages
	pushd "locales/" >/dev/null || die "location change for language cleanup failed"
	chromium_remove_language_paks
	popd >/dev/null || die "location reset for language cleanup failed"
	# fix .desktop exec location
	sed -i "/Exec/s:/usr/share/discord/Discord:${DESTDIR}/${MY_PN^}:" \
		"${MY_PN}.desktop" ||
		die "fixing of exec location on .desktop failed"
	# USE seccomp
	if ! use seccomp; then
		sed -i '/Exec/s/Discord/Discord --disable-seccomp-filter-sandbox/' \
			"${MY_PN}.desktop" ||
			die "sed failed for seccomp"
	fi
	# USE system-ffmpeg
	if use system-ffmpeg; then
		rm libffmpeg.so || die
		elog "Using system ffmpeg. This is experimental and may lead to crashes."
	fi
}

src_install() {
	doicon -s 256 "${MY_PN}.png"

	# install .desktop file
	domenu "${MY_PN}.desktop"

	exeinto "${DESTDIR}"

	doexe "${MY_PN^}" chrome-sandbox libEGL.so libGLESv2.so libvk_swiftshader.so

	if use system-ffmpeg; then
		dosym "../../usr/$(get_libdir)/chromium/libffmpeg.so" "${DESTDIR}/libffmpeg.so" || die
	else
		doexe libffmpeg.so
	fi

	insinto "${DESTDIR}"
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin v8_context_snapshot.bin
	insopts -m0755
	doins -r locales resources swiftshader

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fowners root "${DESTDIR}/chrome-sandbox"
	fperms 4711 "${DESTDIR}/chrome-sandbox"

	dosym "${DESTDIR}/${MY_PN^}" "/usr/bin/${MY_PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "sound support" \
		media-sound/pulseaudio media-sound/apulse[sdk] media-video/pipewire
	optfeature "system tray support" dev-libs/libappindicator
}
