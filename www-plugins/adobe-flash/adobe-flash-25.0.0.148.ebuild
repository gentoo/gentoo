# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit nsplugins multilib multilib-minimal

DESCRIPTION="Adobe Flash Player"
HOMEPAGE="
	http://www.adobe.com/products/flashplayer.html
	http://get.adobe.com/flashplayer/
	https://helpx.adobe.com/security/products/flash-player.html
"

AF_URI="https://fpdownload.adobe.com/pub/flashplayer/pdc/${PV}"
AF_NP_32_URI="${AF_URI}/flash_player_npapi_linux.i386.tar.gz -> ${P}-npapi.i386.tar.gz"
AF_NP_64_URI="${AF_URI}/flash_player_npapi_linux.x86_64.tar.gz -> ${P}-npapi.x86_64.tar.gz"
AF_PP_32_URI="${AF_URI}/flash_player_ppapi_linux.i386.tar.gz -> ${P}-ppapi.i386.tar.gz"
AF_PP_64_URI="${AF_URI}/flash_player_ppapi_linux.x86_64.tar.gz -> ${P}-ppapi.x86_64.tar.gz"

IUSE="+nsplugin +ppapi"
REQUIRED_USE="
	|| ( nsplugin ppapi )
"

SRC_URI="
	nsplugin? (
		abi_x86_32? ( ${AF_NP_32_URI} )
		abi_x86_64? ( ${AF_NP_64_URI} )
	)
	ppapi? (
		abi_x86_32? ( ${AF_PP_32_URI} )
		abi_x86_64? ( ${AF_PP_64_URI} )
	)
"
SLOT="22"

KEYWORDS="-* amd64 x86"
LICENSE="AdobeFlash-11.x"
RESTRICT="strip mirror"

NPAPI_RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/fontconfig
	media-libs/freetype
	>=sys-libs/glibc-2.4
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango
"
RDEPEND="
	!www-plugins/chrome-binary-plugins[flash(-)]
	nsplugin? (
		${NPAPI_RDEPEND}
		!www-plugins/adobe-flash:0
	)
"

S="${WORKDIR}"

# Ignore QA warnings in these closed-source binaries, since we can't fix them:
QA_PREBUILT="usr/*"

src_unpack() {
	local files=( ${A} )

	multilib_src_unpack() {
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die

		# we need to filter out the other archive(s)
		local other_abi
		[[ ${ABI} == amd64 ]] && other_abi=i386 || other_abi=x86_64
		unpack ${files[@]//*${other_abi}*/}
	}

	multilib_parallel_foreach_abi multilib_src_unpack
}

multilib_src_install() {
	local pkglibdir=lib
	[[ -d usr/lib64 ]] && pkglibdir=lib64

	if use nsplugin; then
		# PLUGINS_DIR comes from nsplugins.eclass
		exeinto /usr/$(get_libdir)/${PLUGINS_DIR}
		doexe libflashplayer.so

		if multilib_is_native_abi; then
			# No KDE applet, so allow the GTK utility to show up in KDE:
			sed \
				-i usr/share/applications/flash-player-properties.desktop \
				-e "/^NotShowIn=KDE;/d" || die

			# The userland 'flash-player-properties' standalone app:
			dobin usr/bin/flash-player-properties

			# Icon and .desktop for 'flash-player-properties'
			insinto /usr/share
			doins -r usr/share/{icons,applications}
			dosym ../icons/hicolor/48x48/apps/flash-player-properties.png \
				/usr/share/pixmaps/flash-player-properties.png
		fi

		# The magic config file!
		insinto "/etc/adobe"
		doins "${FILESDIR}/mms.cfg"
	fi

	if use ppapi; then
		exeinto /usr/$(get_libdir)/chromium/PepperFlash
		doexe libpepflashplayer.so
		insinto /usr/$(get_libdir)/chromium/PepperFlash
		doins manifest.json

		if multilib_is_native_abi; then
			dodir /etc/chromium
			sed "${FILESDIR}"/pepper-flash-r1 \
				-e "s|@FP_LIBDIR@|$(get_libdir)|g" \
				-e "s|@FP_PV@|${PV}|g" \
				> "${D}"/etc/chromium/pepper-flash \
				|| die
		fi
	fi
}
