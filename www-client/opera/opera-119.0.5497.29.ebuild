# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	bg bn ca cs da de el en-GB en-US es-419 es fil fi fr hi hr hu id
	it ja ko lt lv ms nb nl pl pt-BR pt-PT ro ru sk sr sv sw ta te th tr uk vi
	zh-CN zh-TW
"

# These are intended for ebuild maintainer use to force RPM if DEB is not available.
: ${OPERA_FORCE_RPM=no}

inherit chromium-2 pax-utils xdg

if [[ ${OPERA_FORCE_RPM} == yes ]]; then
	inherit rpm
	OPERA_ARCHIVE_EXT="rpm"
else
	inherit unpacker
	OPERA_ARCHIVE_EXT="deb"
fi

DESCRIPTION="A fast and secure web browser"
HOMEPAGE="https://www.opera.com/"

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

# Commit ref from `strings libffmpeg.so | grep -F "FFmpeg version"` matches this Chromium version
# used to select the correct ffmpeg-chromium version (corresponds to a major version of Chromium)
# Does not need to be updated for every new version of Opera, only when it breaks
CHROMIUM_VERSION="134"
SRC_URI="${SRC_URI_BASE[@]/%//${PV}/linux/${MY_PN}_${PV}_amd64.${OPERA_ARCHIVE_EXT}}"
S=${WORKDIR}

LICENSE="OPERA-2018"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="+ffmpeg-chromium +proprietary-codecs +suid qt6"
RESTRICT="bindist mirror strip"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gsettings-desktop-schemas
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
	proprietary-codecs? (
		!ffmpeg-chromium? ( >=media-video/ffmpeg-6.1-r1:0/58.60.60[chromium] )
		ffmpeg-chromium? ( media-video/ffmpeg-chromium:${CHROMIUM_VERSION} )
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"

QA_PREBUILT="*"
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
	if [[ ${OPERA_FORCE_RPM} == yes ]]; then
		rpm_src_unpack "${A[0]}"
	else
		unpacker
	fi

	# move to /opt, bug #573052
	mkdir -p "${OPERA_HOME%${PN}}"
	if [[ ${OPERA_FORCE_RPM} == yes ]]; then
		mv "usr/lib64/${PN}" "${OPERA_HOME%${PN}}" || die
	else
		mv "usr/lib/x86_64-linux-gnu/${PN}" "${OPERA_HOME%${PN}}" || die
	fi
	rm -r "usr/lib" || die

	# disable auto update
	rm "${OPERA_HOME}/${PN%-*}_autoupdate"{,.licenses,.version} || die

	if [[ ${OPERA_FORCE_RPM} == yes ]]; then
		rm "${OPERA_HOME}/setup_repo.sh" || die
	else
		rm -r "usr/share/lintian" || die

		# fix docs
		mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die
		gzip -d usr/share/doc/${PF}/changelog.gz || die
	fi

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
		dosym ../../usr/$(get_libdir)/chromium/libffmpeg.so$(usex ffmpeg-chromium .${CHROMIUM_VERSION} "") \
			  /${OPERA_HOME}/libffmpeg.so
	fi

	rm "${OPERA_HOME}/libqt5_shim.so" || die
	if ! use qt6; then
		rm "${OPERA_HOME}/libqt6_shim.so" || die
	fi

	# pax mark opera, bug #562038
	pax-mark m "${OPERA_HOME}/opera"
	# enable suid sandbox if requested
	use suid && fperms 4711 "/${OPERA_HOME}/opera_sandbox"
}
