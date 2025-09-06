# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MOZ_ESR=yes

MOZ_PV=${PV}
MOZ_PV_SUFFIX=
if [[ ${PV} =~ (_(alpha|beta|rc).*)$ ]] ; then
	MOZ_PV_SUFFIX=${BASH_REMATCH[1]}

	# Convert the ebuild version to the upstream Mozilla version
	MOZ_PV="${MOZ_PV/_alpha/a}" # Handle alpha for SRC_URI
	MOZ_PV="${MOZ_PV/_beta/b}"  # Handle beta for SRC_URI
	MOZ_PV="${MOZ_PV%%_rc*}"    # Handle rc for SRC_URI
fi

if [[ -n ${MOZ_ESR} ]] ; then
	# ESR releases have slightly different version numbers
	MOZ_PV="${MOZ_PV}esr"
fi

MOZ_PN="${PN%-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

inherit desktop optfeature pax-utils xdg

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

SRC_URI="amd64? ( ${MOZ_SRC_BASE_URI}/linux-x86_64/en-US/${MOZ_P}.tar.xz -> ${PN}_x86_64-${PV}.tar.xz )
	x86? ( ${MOZ_SRC_BASE_URI}/linux-i686/en-US/${MOZ_P}.tar.xz -> ${PN}_i686-${PV}.tar.xz )"

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="https://www.thunderbird.net/"

if [[ -n ${MOZ_ESR} ]] ; then
	SLOT="0/esr"
else
	SLOT="0/stable"
fi

KEYWORDS="-* ~amd64 ~x86"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="selinux wayland"

RESTRICT="strip"

BDEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	|| (
		media-libs/libpulse
		media-sound/apulse
	)
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.26:2
	media-libs/alsa-lib
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	sys-apps/dbus
	virtual/freedesktop-icon-theme
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.11:3[X,wayland?]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	>=x11-libs/pango-1.22.0
	selinux? ( sec-policy/selinux-thunderbird )
"

QA_PREBUILT="opt/${MOZ_PN}/*"

MOZ_LANGS=(
	af ar ast be bg br ca cak cs cy da de dsb
	el en-CA en-GB en-US es-AR es-ES es-MX et eu
	fi fr fy-NL ga-IE gd gl he hr hsb hu
	id is it ja ka kab kk ko lt lv ms nb-NO nl nn-NO
	pa-IN pl pt-BR pt-PT rm ro ru
	sk sl sq sr sv-SE th tr uk uz vi zh-CN zh-TW
)

mozilla_set_globals() {
	# https://bugs.gentoo.org/587334
	local MOZ_TOO_REGIONALIZED_FOR_L10N=(
		fy-NL ga-IE gu-IN hi-IN hy-AM nb-NO ne-NP nn-NO pa-IN sv-SE
	)

	local lang xflag
	for lang in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${lang} == en ]] || [[ ${lang} == en-US ]] ; then
			continue
		fi

		# strip region subtag if $lang is in the list
		if has ${lang} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag=${lang%%-*}
		else
			xflag=${lang}
		fi

		SRC_URI+=" l10n_${xflag/[_@]/-}? ("
		SRC_URI+=" ${MOZ_SRC_BASE_URI}/linux-x86_64/xpi/${lang}.xpi -> ${MOZ_P_DISTFILES}-${lang}.xpi"
		SRC_URI+=" )"
		IUSE+=" l10n_${xflag/[_@]/-}"
	done
}
mozilla_set_globals

moz_install_xpi() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local DESTDIR=${1}
	shift

	insinto "${DESTDIR}"

	local emid xpi_file xpi_tmp_dir
	for xpi_file in "${@}" ; do
		emid=
		xpi_tmp_dir=$(mktemp -d --tmpdir="${T}")

		# Unpack XPI
		unzip -qq "${xpi_file}" -d "${xpi_tmp_dir}" || die

		# Determine extension ID
		if [[ -f "${xpi_tmp_dir}/install.rdf" ]] ; then
			emid=$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${xpi_tmp_dir}/install.rdf")
			[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n -e 's/.*"id": "\([^"]*\)".*/\1/p' "${xpi_tmp_dir}/manifest.json")
			[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
		else
			die "failed to determine extension id"
		fi

		einfo "Installing ${emid}.xpi into ${ED}${DESTDIR} ..."
		newins "${xpi_file}" "${emid}.xpi"
	done
}

src_unpack() {
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	mkdir "${S}" || die

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			cp "${DISTDIR}/${_src_file}" "${_lp_dir}" || die "Failed to copy '${_src_file}' to '${_lp_dir}'!"
		else
			MY_SRC_FILE=${_src_file}
		fi
	done
}

src_install() {
	# Set MOZILLA_FIVE_HOME
	local MOZILLA_FIVE_HOME="/opt/${MOZ_PN}"

	dodir /opt
	pushd "${ED}"/opt &>/dev/null || die
	unpack "${MY_SRC_FILE}"
	popd &>/dev/null || die

	pax-mark m \
		"${ED}${MOZILLA_FIVE_HOME}"/${MOZ_PN} \
		"${ED}${MOZILLA_FIVE_HOME}"/${MOZ_PN}-bin

	# Install policy (currently only used to disable application updates)
	insinto "${MOZILLA_FIVE_HOME}/distribution"
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/defaults/pref"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}"/gentoo-default-prefs-r1.js gentoo-prefs.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/gentoo-prefs.js"

	# Install language packs
	local langpacks=( $(find "${WORKDIR}/language_packs" -type f -name '*.xpi') )
	if [[ -n "${langpacks}" ]] ; then
		moz_install_xpi "${MOZILLA_FIVE_HOME}/distribution/extensions" "${langpacks[@]}"
	fi

	# Install icons
	local icon_srcdir="${ED}/${MOZILLA_FIVE_HOME}/chrome/icons/default"

	local icon size
	for icon in "${icon_srcdir}"/default*.png ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" ${PN}.png
		fi

		newicon -s ${size} "${icon}" ${PN}.png
	done

	# Install menu
	local app_name="Mozilla ${MOZ_PN^} (bin)"
	local desktop_file="${FILESDIR}/icon/${PN}-r3.desktop"
	local desktop_filename="${PN}.desktop"
	local exec_command="${PN}"
	local icon="${PN}"
	local use_wayland="false"

	if use wayland ; then
		use_wayland="true"
	fi

	if [[ -n ${MOZ_ESR} ]] ; then
		local wmclass="thunderbird-esr"
	else
		local wmclass="thunderbird"
	fi

	cp "${desktop_file}" "${WORKDIR}/${PN}.desktop-template" || die

	# Add apulse support through our wrapper shell launcher, patchelf-method broken since 119.0.
	# See bgo#916230, bgo#941873
	local apulselib=
	if has_version -r media-sound/apulse[-sdk] ; then
		apulselib="${EPREFIX}/usr/$(get_libdir)/apulse"
		ewarn "media-sound/apulse with -sdk use flag detected!"
		ewarn "Thunderbird-bin will be installed with a wrapper, that attempts to load"
		ewarn "apulse instead of pipewire/pulseadio. This may lead to sound issues."
		ewarn "Please either enable sdk use flag for apulse, or remove apulse"
		ewarn "completely and re-install thunderbird-bin to utilize pipewire/pulseaudio instead."
	fi

	sed -i \
		-e "s:@NAME@:${app_name}:" \
		-e "s:@EXEC@:${exec_command}:" \
		-e "s:@ICON@:${icon}:" \
		-e "s:@CLASS@:${wmclass}:" \
			"${WORKDIR}/${PN}.desktop-template" || die

	newmenu "${WORKDIR}/${PN}.desktop-template" "${desktop_filename}"

	rm "${WORKDIR}/${PN}.desktop-template" || die

	# Install wrapper script
	[[ -f "${ED}/usr/bin/${PN}" ]] && rm "${ED}/usr/bin/${PN}"
	newbin "${FILESDIR}/${PN}-r1.sh" ${PN}

	# Update wrapper
	sed -i \
		-e "s:@PREFIX@:${EPREFIX}/usr:" \
		-e "s:@MOZ_FIVE_HOME@:${EPREFIX}${MOZILLA_FIVE_HOME}:" \
		-e "s:@APULSELIB_DIR@:${apulselib}:" \
		-e "s:@DEFAULT_WAYLAND@:${use_wayland}:" \
		"${ED}/usr/bin/${PN}" \
		|| die
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Optional programs for extra features:"
	optfeature "fallback mouse cursor theme e.g. on WMs" gnome-base/gsettings-desktop-schemas
	optfeature "ffmpeg-based audio/video codec support, required for HTML5 video rendering" media-video/ffmpeg
	optfeature "encrypted chat support" net-libs/libotr
	optfeature "desktop notifications" x11-libs/libnotify
}
