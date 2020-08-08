# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MOZ_ESR=1

# Can be updated using scripts/get_langs.sh from mozilla overlay
MOZ_LANGS=(ach af an ar ast az be bg bn br bs ca cak cs cy da de dsb el en en-CA
en-GB en-US eo es-AR es-CL es-ES es-MX et eu fa ff fi fr fy-NL ga-IE gd gl gn gu-IN
he hi-IN hr hsb hu hy-AM ia id is it ja ka kab kk km kn ko lij lt lv mk mr ms my
nb-NO nl nn-NO oc pa-IN pl pt-BR pt-PT rm ro ru si sk sl son sq sr sv-SE ta te
th tr uk ur uz vi xh zh-CN zh-TW )

# Convert the ebuild version to the upstream mozilla version, used by mozlinguas
MOZ_PV="${PV/_beta/b}" # Handle beta for SRC_URI
MOZ_PV="${MOZ_PV/_rc/rc}" # Handle rc for SRC_URI
MOZ_PN="${PN/-bin}"
if [[ ${MOZ_ESR} == 1 ]]; then
	# ESR releases have slightly version numbers
	MOZ_PV="${MOZ_PV}esr"
fi
MOZ_P="${MOZ_PN}-${MOZ_PV}"

MOZ_HTTP_URI="https://archive.mozilla.org/pub/mozilla.org/${MOZ_PN}/releases/"

inherit mozlinguas-v2 nsplugins pax-utils xdg-utils eapi7-ver

DESCRIPTION="Firefox Web Browser"
SRC_URI="${SRC_URI}
	amd64? ( ${MOZ_HTTP_URI%/}/${MOZ_PV}/linux-x86_64/en-US/${MOZ_P}.tar.bz2 -> ${PN}_x86_64-${PV}.tar.bz2 )
	x86? ( ${MOZ_HTTP_URI%/}/${MOZ_PV}/linux-i686/en-US/${MOZ_P}.tar.bz2 -> ${PN}_i686-${PV}.tar.bz2 )"
HOMEPAGE="https://www.mozilla.org/en-US/firefox/"
RESTRICT="strip mirror"

KEYWORDS="-* amd64 x86"
SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="+alsa +ffmpeg +pulseaudio selinux startup-notification wayland"

DEPEND="app-arch/unzip
	alsa? (
		!pulseaudio? (
			dev-util/patchelf
			media-sound/apulse
		)
	)"
RDEPEND="dev-libs/atk
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.72
	>=dev-libs/glib-2.26:2
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-2.18:2
	>=x11-libs/gtk+-3.4.0:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/pango-1.22.0
	virtual/freedesktop-icon-theme
	alsa? (
		!pulseaudio? (
			media-sound/apulse
		)
	)
	pulseaudio? ( media-sound/pulseaudio )
	ffmpeg? ( media-video/ffmpeg )
	selinux? ( sec-policy/selinux-mozilla )
"

QA_PREBUILT="
	opt/${MOZ_PN}/*.so
	opt/${MOZ_PN}/${MOZ_PN}
	opt/${MOZ_PN}/${PN}
	opt/${MOZ_PN}/crashreporter
	opt/${MOZ_PN}/webapprt-stub
	opt/${MOZ_PN}/plugin-container
	opt/${MOZ_PN}/mozilla-xremote-client
	opt/${MOZ_PN}/updater
	opt/${MOZ_PN}/minidump-analyzer
	opt/${MOZ_PN}/pingsender
"

S="${WORKDIR}/${MOZ_PN}"

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack
}

src_install() {
	local MOZILLA_FIVE_HOME=/opt/${MOZ_PN}

	# Install firefox in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${ED%/}"${MOZILLA_FIVE_HOME} || die
	cd "${WORKDIR}" || die

	# Install language packs
	MOZEXTENSION_TARGET="distribution/extensions" \
		MOZ_INSTALL_L10N_XPIFILE="1" \
		mozlinguas_src_install

	# Disable built-in auto-update because we update firefox-bin through package manager
	insinto ${MOZILLA_FIVE_HOME}/distribution/
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Fix prefs that make no sense for a system-wide install
	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/
	doins "${FILESDIR}"/local-settings.js
	insinto ${MOZILLA_FIVE_HOME}
	newins "${FILESDIR}"/all-gentoo-3.js all-gentoo.js

	local size sizes icon_path icon name
	sizes="16 32 48 128"
	icon_path="${MOZILLA_FIVE_HOME}/browser/chrome/icons/default"
	icon="${PN}"
	name="Mozilla Firefox (bin)"

	local apulselib=
	if use alsa && ! use pulseaudio; then
		apulselib="${EPREFIX%/}/usr/$(get_libdir)/apulse"
		patchelf --set-rpath "${apulselib}" "${ED%/}"${MOZILLA_FIVE_HOME}/libxul.so || die
	fi

	# Install icons and .desktop for menu entry
	for size in ${sizes} ; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${ED%/}${icon_path}/default${size}.png" "${icon}.png"
	done
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${ED%/}${MOZILLA_FIVE_HOME}/browser/chrome/icons/default/default48.png" ${PN}.png

	# Add StartupNotify=true bug 237317
	local startup_notify="false"
	if use startup-notification ; then
		startup_notify="true"
	fi

	local display_protocols="auto X11" use_wayland="false"
	if use wayland ; then
		display_protocols+=" Wayland"
		use_wayland="true"
	fi

	local app_name desktop_filename display_protocol exec_command
	for display_protocol in ${display_protocols} ; do
		app_name="${name} on ${display_protocol}"
		desktop_filename="${PN}-${display_protocol,,}.desktop"

		case ${display_protocol} in
			Wayland)
				exec_command="${PN}-wayland --name ${PN}-wayland"
				newbin "${FILESDIR}"/firefox-bin-wayland.sh ${PN}-wayland
				;;
			X11)
				if ! use wayland ; then
					# Exit loop here because there's no choice so
					# we don't need wrapper/.desktop file for X11.
					continue
				fi

				exec_command="${PN}-x11 --name ${PN}-x11"
				newbin "${FILESDIR}"/firefox-bin-x11.sh ${PN}-x11
				;;
			*)
				app_name="${name}"
				desktop_filename="${PN}.desktop"
				exec_command='firefox-bin'
				;;
		esac

		newmenu "${FILESDIR}/${PN}-r1.desktop" "${desktop_filename}"
		sed -i \
			-e "s:@NAME@:${app_name}:" \
			-e "s:@EXEC@:${exec_command}:" \
			-e "s:@ICON@:${icon}:" \
			-e "s:@STARTUP_NOTIFY@:${startup_notify}:" \
			"${ED%/}/usr/share/applications/${desktop_filename}" || die
	done

	rm -f "${ED%/}"/usr/bin/firefox-bin || die
	newbin "${FILESDIR}"/firefox-bin.sh firefox-bin

	local wrapper
	for wrapper in \
		"${ED%/}"/usr/bin/firefox-bin \
		"${ED%/}"/usr/bin/firefox-bin-x11 \
		"${ED%/}"/usr/bin/firefox-bin-wayland \
	; do
		[[ ! -f "${wrapper}" ]] && continue

		sed -i \
			-e "s:@PREFIX@:${EPREFIX%/}/usr:" \
			-e "s:@MOZ_FIVE_HOME@:${MOZILLA_FIVE_HOME}:" \
			-e "s:@APULSELIB_DIR@:${apulselib}:" \
			-e "s:@DEFAULT_WAYLAND@:${use_wayland}:" \
			"${wrapper}" || die
	done

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=${MOZILLA_FIVE_HOME}" >> ${T}/10${PN}
	doins "${T}"/10${PN}

	# Plugins dir, still used for flash
	share_plugins_dir

	# Required in order to use plugins and even run firefox on hardened.
	pax-mark mr "${ED%/}"${MOZILLA_FIVE_HOME}/{firefox,firefox-bin,plugin-container}
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	xdg_desktop_database_update
	xdg_icon_cache_update

	if ! has_version 'gnome-base/gconf' || ! has_version 'gnome-base/orbit' \
		|| ! has_version 'net-misc/curl'; then
		einfo
		einfo "For using the crashreporter, you need gnome-base/gconf,"
		einfo "gnome-base/orbit and net-misc/curl emerged."
		einfo
	fi
	use ffmpeg || ewarn "USE=-ffmpeg : HTML5 video will not render without media-video/ffmpeg installed"

	local HAS_AUDIO=0
	if use alsa || use pulseaudio; then
		HAS_AUDIO=1
	fi

	if [[ ${HAS_AUDIO} -eq 0 ]] ; then
		ewarn "USE=-pulseaudio & USE=-alsa : For audio please either set USE=pulseaudio or USE=alsa!"
	fi

	local show_normandy_information

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		# New install
		show_normandy_information=yes
	else
		local replacing_version
		for replacing_version in ${REPLACING_VERSIONS} ; do
			if ver_test "${replacing_version}" -lt 68.6.0-r1 ; then
				# Tell user only once about our Normandy default
				show_normandy_information=yes
				break
			fi
		done
	fi

	# bug 713782
	if [[ -n "${show_normandy_information}" ]] ; then
		elog
		elog "Upstream operates a service named Normandy which allows Mozilla to"
		elog "push changes for default settings or even install new add-ons remotely."
		elog "While this can be useful to address problems like 'Armagadd-on 2.0' or"
		elog "revert previous decisions to disable TLS 1.0/1.1, privacy and security"
		elog "concerns prevail, which is why we have switched off the use of this"
		elog "service by default."
		elog
		elog "To re-enable this service set"
		elog
		elog "    app.normandy.enabled=true"
		elog
		elog "in about:config."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
