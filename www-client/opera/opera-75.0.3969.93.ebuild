# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CHROMIUM_LANGS="
	be bg bn ca cs da de el en-GB en-US es-419 es fil fi fr-CA fr hi hr hu id
	it ja ko lt lv ms nb nl pl pt-BR pt-PT ro ru sk sr sv sw ta te th tr uk vi
	zh-CN zh-TW
"
inherit chromium-2 multilib pax-utils unpacker xdg

DESCRIPTION="A fast and secure web browser"
HOMEPAGE="https://www.opera.com/"
LICENSE="OPERA-2018"
SLOT="0"

SRC_URI_BASE=(
	"https://download1.operacdn.com/pub/${PN}"
	"https://download2.operacdn.com/pub/${PN}"
	"https://download3.operacdn.com/pub/${PN}"
	"https://download4.operacdn.com/pub/${PN}"
)

if [[ ${PN} == opera ]]; then
	MY_PN=${PN}-stable
	SRC_URI_BASE=( "${SRC_URI_BASE[@]/%//desktop}" )
else
	MY_PN=${PN}
fi

KEYWORDS="-* ~amd64"

FFMPEG_VERSION="89.0.4381.8"

SRC_URI="${SRC_URI_BASE[@]/%//${PV}/linux/${MY_PN}_${PV}_amd64.deb}
	proprietary-codecs? (
		https://dev.gentoo.org/~sultan/distfiles/www-client/opera/opera-ffmpeg-codecs-${FFMPEG_VERSION}.tar.xz
	)"

IUSE="+proprietary-codecs suid widevine"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gsettings-desktop-schemas
	media-libs/alsa-lib
	media-libs/mesa[gbm]
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
	widevine? ( www-plugins/chrome-binary-plugins )
"

QA_PREBUILT="*"
S=${WORKDIR}
OPERA_HOME="opt/opera${PN#opera}"

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "opera only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	# move to /opt, bug #573052
	mkdir -p "${OPERA_HOME%${PN}}"
	mv "usr/lib/x86_64-linux-gnu/${PN}" "${OPERA_HOME%${PN}}" || die
	rm -r "usr/lib" || die

	# disable auto update
	rm "${OPERA_HOME}/${PN%-*}_autoupdate"{,.licenses,.version} || die

	rm -r "usr/share/lintian" || die

	# fix docs
	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die
	gzip -d usr/share/doc/${PF}/changelog.gz || die

	# fix desktop file
	sed -i \
		-e 's|^TargetEnvironment|X-&|g' \
		usr/share/applications/${PN}.desktop || die

	# remove unused language packs
	pushd "${OPERA_HOME}/localization" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# setup opera symlink
	rm "usr/bin/${PN}" || die
	dosym "../../${OPERA_HOME}/${PN}" "/usr/bin/${PN}"

	# install proprietary codecs
	rm "${OPERA_HOME}/resources/ffmpeg_preload_config.json" || die
	if use proprietary-codecs; then
		mv lib_extra "${OPERA_HOME}"
	fi

	# symlink widevine
	rm "${OPERA_HOME}/resources/widevine_config.json" || die
	if use widevine; then
		echo "[\"${EPREFIX}/usr/$(get_libdir)/chromium-browser/WidevineCdm\"]" > \
			"${OPERA_HOME}/resources/widevine_config.json" || die
	fi

	# pax mark opera, bug #562038
	pax-mark m "${OPERA_HOME}/opera"
	# enable suid sandbox if requested
	use suid && fperms 4711 "${OPERA_HOME}/opera_sandbox"
}
