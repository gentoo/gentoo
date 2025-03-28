# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin/}"
MY_PV="${PV/-r*/}"

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop linux-info optfeature unpacker xdg

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discord.com/"
SRC_URI="https://dl.discordapp.net/apps/linux/${MY_PV}/${MY_PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${MY_PN^}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"

IUSE="appindicator +seccomp wayland"
RESTRICT="bindist mirror strip test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
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
	appindicator? ( dev-libs/libayatana-appindicator )
"

DESTDIR="/opt/${MY_PN}"

QA_PREBUILT="*"

CONFIG_CHECK="~USER_NS"

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
	sed --in-place --expression "/^Exec=/s:/usr/share/discord/Discord:/usr/bin/${MY_PN}:" \
		"${MY_PN}.desktop" ||
		die "fixing of exec location on .desktop failed"

	# Update exec location in launcher
	sed --expression "s:@@DESTDIR@@:${DESTDIR}:" \
		"${FILESDIR}/launcher.sh" > "${T}/launcher.sh" || die "updating of exec location in launcher failed"

	# USE seccomp in launcher
	if use seccomp; then
		sed --in-place --expression '/^EBUILD_SECCOMP=/s/false/true/' \
			"${T}/launcher.sh" || die "sed failed for seccomp"
	fi

	# USE wayland in launcher
	if use wayland; then
		sed --in-place --expression '/^EBUILD_WAYLAND=/s/false/true/' \
			"${T}/launcher.sh" || die "sed failed for wayland"
	fi
}

src_install() {
	doicon -s 256 "${MY_PN}.png"

	# install .desktop file
	domenu "${MY_PN}.desktop"

	exeinto "${DESTDIR}"

	doexe "${MY_PN^}" chrome-sandbox libEGL.so libffmpeg.so libGLESv2.so libvk_swiftshader.so

	insinto "${DESTDIR}"
	doins chrome_100_percent.pak chrome_200_percent.pak icudtl.dat resources.pak snapshot_blob.bin v8_context_snapshot.bin
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fowners root "${DESTDIR}/chrome-sandbox"
	fperms 4711 "${DESTDIR}/chrome-sandbox"

	# Crashpad is included in the package once in a while and when it does, it must be installed.
	# See #903616 and #890595
	[[ -x chrome_crashpad_handler ]] && doins chrome_crashpad_handler

	exeinto "/usr/bin"
	newexe "${T}/launcher.sh" "discord" || die "failing to install launcher"

	# https://bugs.gentoo.org/898912
	if use appindicator; then
		dosym ../../usr/lib64/libayatana-appindicator3.so /opt/discord/libappindicator3.so
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Install the following packages for additional support:"
	optfeature "sound support" \
		media-sound/pulseaudio media-sound/apulse[sdk] media-video/pipewire
	optfeature "emoji support" media-fonts/noto-emoji
	if has_version kde-plasma/kwin[-screencast] && use wayland; then
		einfo " "
		einfo "When using KWin on Wayland, the kde-plasma/kwin[screencast] USE flag"
		einfo "must be enabled for screensharing."
		einfo " "
	fi
}
