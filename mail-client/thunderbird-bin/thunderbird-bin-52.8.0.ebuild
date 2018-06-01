# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MOZ_ESR=""
MOZ_LIGHTNING_VER="5.4.8"

# Can be updated using scripts/get_langs.sh from mozilla overlay
MOZ_LANGS=(ar ast be bg bn-BD br ca cs cy da de el en en-GB en-US es-AR
es-ES et eu fi fr fy-NL ga-IE gd gl he hr hsb hu hy-AM id is it ja ko lt
nb-NO nl nn-NO pa-IN pl pt-BR pt-PT rm ro ru si sk sl sq sr sv-SE ta-LK tr
uk vi zh-CN zh-TW )

# Convert the ebuild version to the upstream mozilla version, used by
MOZ_PN="${PN/-bin}"
MOZ_PV="${PV/_beta/b}"
MOZ_PV="${MOZ_PV/_rc/rc}"

if [[ ${MOZ_ESR} == 1 ]]; then
	# ESR releases have slightly version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

MOZ_P="${MOZ_PN}-${MOZ_PV}"

MOZ_HTTP_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases"

inherit eutils multilib pax-utils xdg-utils gnome2-utils nsplugins mozlinguas-v2

DESCRIPTION="Thunderbird Mail Client"
SRC_URI="${SRC_URI}
	amd64? ( ${MOZ_HTTP_URI}/${MOZ_PV}/linux-x86_64/en-US/${MOZ_P}.tar.bz2 -> ${PN}_x86_64-${PV}.tar.bz2 )
	x86? ( ${MOZ_HTTP_URI}/${MOZ_PV}/linux-i686/en-US/${MOZ_P}.tar.bz2 -> ${PN}_i686-${PV}.tar.bz2 )
	https://dev.gentoo.org/~axs/distfiles/lightning-${MOZ_LIGHTNING_VER}.tar.xz
"
# the below only works when upstream releases the xpi with all locales bundled
#	${MOZ_HTTP_URI/${MOZ_PN}/calendar/lightning}/${MOZ_LIGHTNING_VER}/linux/lightning.xpi -> lightning-${MOZ_LIGHTNING_VER}.xpi

HOMEPAGE="http://www.mozilla.com/thunderbird"
RESTRICT="strip mirror"

KEYWORDS="-* amd64 x86"
SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="+crashreporter +ffmpeg +pulseaudio selinux"

DEPEND="app-arch/unzip"

RDEPEND="virtual/freedesktop-icon-theme
	dev-libs/atk
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.72
	>=dev-libs/glib-2.26:2
	>=media-libs/alsa-lib-1.0.16
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10:2
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.4.0:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/pango-1.22.0
	pulseaudio? ( !<media-sound/apulse-0.1.9
		|| ( media-sound/pulseaudio media-sound/apulse ) )
	ffmpeg? ( media-video/ffmpeg )
	crashreporter? ( net-misc/curl )
	selinux? ( sec-policy/selinux-thunderbird )
"

QA_PREBUILT="
	opt/${MOZ_PN}/*.so
	opt/${MOZ_PN}/${MOZ_PN}
	opt/${MOZ_PN}/${PN}
	opt/${MOZ_PN}/crashreporter
	opt/${MOZ_PN}/plugin-container
	opt/${MOZ_PN}/mozilla-xremote-client
	opt/${MOZ_PN}/updater
"

S="${WORKDIR}/${MOZ_PN}"

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack
	#xpi_unpack lightning-${MOZ_LIGHTNING_VER}.xpi
}

src_install() {
	declare MOZILLA_FIVE_HOME="/opt/${MOZ_PN}"

	local size sizes icon_path icon name
	sizes="16 22 24 32 48 256"
	icon_path="${S}/chrome/icons/default"
	icon="${PN}-icon"
	name="Thunderbird"

	# Install icons and .desktop for menu entry
	for size in ${sizes}; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${icon_path}/default${size}.png" "${icon}.png"
	done
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${S}"/chrome/icons/default/default48.png "${icon}.png"
	domenu "${FILESDIR}"/icon/${PN}.desktop

	# Install thunderbird in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${ED}"${MOZILLA_FIVE_HOME}
	cd "${WORKDIR}" || die # PWD no longer exists so move to somewhere that does

	# Install language packs
	MOZEXTENSION_TARGET="distribution/bundles" \
	mozlinguas_src_install

	# Install language packs for calendar
	mozlinguas_xpistage_langpacks \
		"${ED%/}/${MOZILLA_FIVE_HOME%/}/distribution/extensions/{e2fda1a4-762b-4020-b5ad-a41df1933103}" \
		"${WORKDIR}"/lightning-${MOZ_LIGHTNING_VER} lightning calendar

	# Create /usr/bin/thunderbird-bin
	dodir /usr/bin/
	local apulselib=$(usex pulseaudio "/usr/$(get_libdir)/apulse:" "")
	cat <<EOF >"${D}"/usr/bin/${PN}
#!/bin/sh
unset LD_PRELOAD
LD_LIBRARY_PATH="${apulselib}${MOZILLA_FIVE_HOME}" \\
exec ${MOZILLA_FIVE_HOME}/thunderbird "\$@"
EOF
	fperms 0755 /usr/bin/${PN}

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/10${PN}

	# Enable very specific settings for thunderbird-3
	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/
	newins "${FILESDIR}"/thunderbird-gentoo-default-prefs.js all-gentoo.js

	# Plugins dir
	share_plugins_dir

	pax-mark mr "${ED}"${MOZILLA_FIVE_HOME}/{thunderbird-bin,thunderbird,plugin-container}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

	use ffmpeg || ewarn "USE=-ffmpeg : HTML5 video will not render without media-video/ffmpeg installed"
	use pulseaudio || ewarn "USE=-pulseaudio : audio will not play without pulseaudio installed"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
