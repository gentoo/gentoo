# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin/}"
MY_PV="${PV/-r*/}"

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"
PYTHON_COMPAT=( python3_{11..15} )
UPDATE_DISABLER_COMMIT="2f26748a667045d26bc19841f1a731b4be7a7514"

inherit chromium-2 desktop linux-info optfeature python-single-r1 unpacker xdg

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discord.com/"

SRC_URI="
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/full.distro -> ${P}.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_desktop_core/1/full.distro
		-> ${P}-${MY_PN}_desktop_core.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_erlpack/1/full.distro
		-> ${P}-${MY_PN}_erlpack.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_spellcheck/1/full.distro
		-> ${P}-${MY_PN}_spellcheck.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_utils/1/full.distro
		-> ${P}-${MY_PN}_utils.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_voice/1/full.distro
		-> ${P}-${MY_PN}_voice.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_zstd/1/full.distro
		-> ${P}-${MY_PN}_zstd.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_rpc/1/full.distro
		-> ${P}-${MY_PN}_rpc.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_game_utils/1/full.distro
		-> ${P}-${MY_PN}_game_utils.distro
	https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${MY_PV}/discord_krisp/1/full.distro
		-> ${P}-${MY_PN}_krisp.distro
	https://github.com/flathub/com.discordapp.Discord/raw/${UPDATE_DISABLER_COMMIT}/disable-breaking-updates.py
		-> discord-disable-breaking-updates-${UPDATE_DISABLER_COMMIT}.py
"
S="${WORKDIR}/${MY_PN^}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"

IUSE="appindicator +seccomp wayland"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="bindist mirror strip test"
BDEPEND="app-arch/brotli
	app-arch/zip"
RDEPEND="
	${PYTHON_DEPS}
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
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

repackage_node_modules() {
	brotli -d "${DISTDIR}/${P}"-$1.distro -o "${T}"/$1.tar 2>/dev/null || die
	unpack "${T}"/$1.tar || die
	pushd "${WORKDIR}"/files 2>/dev/null || die
	zip -rq "${WORKDIR}"/$1.zip . || die
	popd 2>/dev/null || die
	mv $1.zip "${S}"/resources/bootstrap/ || die
	rm -r "${WORKDIR}"/files || die
}

src_unpack() {
	# Upstream now only ships an autoupdater, where the binaries downloaded from the
	# upstream package do not contain the app, but instead contain software that
	# downloads and installs the app. To work around this, we manually download
	# the same Brotli-compressed tar archives that the autoupdater would, for both
	# the base app itself and the required Node modules. The Node modules need to be
	# unpacked and installed in ~/.config/discord/${PV}/modules, and luckily the base app
	# can automatically do this for us on the first launch if we package the Node
	# modules into a .zip and put them in <base app location>/resources/bootstrap.
	# Some modules are installed at runtime, but we want to bootstrap those too,
	# so we use a custom <base app location>/resources/bootstrap/manifest.json
	# copied over from $FILESDIR.
	brotli -d "${DISTDIR}/${P}".distro -o "${T}/${P}.tar" 2>/dev/null || die
	unpack "${T}/${P}.tar"
	mv "${WORKDIR}"/files "${S}" || die
	rm "${T}/${P}.tar" || die
	# For any new Node modules, add the Brotli-compressed archive to SRC_URI
	# following the same pattern, and then add a corressponding call to
	# repackage_node_modules here. You can find a list of required modules
	# at <base app location>/resources/bootstrap/manifest.json, as well as
	# running the application and looking for lines in the output about "modules".
	# If checking manifest.json, make sure to check the one directly from upstream,
	# as the one installed on the system is copied over from $FILESDIR.
	repackage_node_modules "discord_desktop_core"
	repackage_node_modules "discord_erlpack"
	repackage_node_modules "discord_spellcheck"
	repackage_node_modules "discord_utils"
	repackage_node_modules "discord_voice"
	repackage_node_modules "discord_zstd"
	repackage_node_modules "discord_rpc"
	repackage_node_modules "discord_game_utils"
	repackage_node_modules "discord_krisp"
}

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "locales/" >/dev/null || die "location change for language cleanup failed"
	chromium_remove_language_paks
	popd >/dev/null || die "location reset for language cleanup failed"

	# Update exec location in launcher
	sed --expression "s:@@DESTDIR@@:${DESTDIR}:" \
		"${FILESDIR}/launcher-r1.sh" > "${T}/launcher.sh" || die "updating of exec location in launcher failed"

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
	cp "${FILESDIR}/manifest.json" resources/bootstrap/manifest.json || die "Failed copying manifest.json"
}

src_install() {
	doicon -s 256 "${MY_PN}.png"

	# install .desktop file
	make_desktop_entry "${EPREFIX}/usr/bin/discord" Discord "${PN}" \
	"Network;InstantMessaging;" \
	"StartupWMClass=discord" \
	"Path=${EPREFIX}/usr/bin"

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

	# https://bugs.gentoo.org/905289
	newins "${DISTDIR}/discord-disable-breaking-updates-${UPDATE_DISABLER_COMMIT}.py" disable-breaking-updates.py
	python_fix_shebang "${ED}/${DESTDIR}/disable-breaking-updates.py"

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
