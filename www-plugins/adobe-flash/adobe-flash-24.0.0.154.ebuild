# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit nsplugins multilib multilib-minimal rpm

DESCRIPTION="Adobe Flash Player"
HOMEPAGE="
	http://www.adobe.com/products/flashplayer.html
	http://get.adobe.com/flashplayer/
	https://helpx.adobe.com/security/products/flash-player.html
"

AF_URI="https://fpdownload.macromedia.com/pub/labs/flashruntimes/flashplayer"
AF_NP_32_URI="${AF_URI}/linux32/flash-player-npapi-${PV}-release.i386.rpm -> ${P}-npapi.i386.rpm"
AF_NP_64_URI="${AF_URI}/linux64/flash-player-npapi-${PV}-release.x86_64.rpm -> ${P}-npapi.x86_64.rpm"
AF_PP_32_URI="${AF_URI}/linux32/flash-player-ppapi-${PV}-release.i386.rpm -> ${P}-ppapi.i386.rpm"
AF_PP_64_URI="${AF_URI}/linux64/flash-player-ppapi-${PV}-release.x86_64.rpm -> ${P}-ppapi.x86_64.rpm"

IUSE="kde +npapi +ppapi"
SRC_URI="
	npapi? (
		abi_x86_32? ( ${AF_NP_32_URI} )
		abi_x86_64? ( ${AF_NP_64_URI} )
	)
	ppapi? (
		abi_x86_32? ( ${AF_PP_32_URI} )
		abi_x86_64? ( ${AF_PP_64_URI} )
	)
"
SLOT="22"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="AdobeFlash-11.x"
RESTRICT="strip mirror"

RDEPEND="
	!www-plugins/chrome-binary-plugins[flash(-)]
	npapi? ( !www-plugins/adobe-flash:0 )
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
		rpm_unpack ${files[@]//*${other_abi}*/}
	}

	multilib_parallel_foreach_abi multilib_src_unpack
}

multilib_src_install() {
	local pkglibdir=lib
	[[ -d usr/lib64 ]] && pkglibdir=lib64

	if use npapi; then
		# PLUGINS_DIR comes from nsplugins.eclass
		exeinto /usr/$(get_libdir)/${PLUGINS_DIR}
		doexe usr/${pkglibdir}/flash-plugin/libflashplayer.so

		if multilib_is_native_abi; then
			if use kde; then
				exeinto /usr/$(get_libdir)/kde4
				doexe usr/${pkglibdir}/kde4/kcm_adobe_flash_player.so
				insinto /usr/share/kde4/services
				doins usr/share/kde4/services/kcm_adobe_flash_player.desktop
			else
				# No KDE applet, so allow the GTK utility to show up in KDE:
				sed -i usr/share/applications/flash-player-properties.desktop \
					-e "/^NotShowIn=KDE;/d" || die "sed of .desktop file failed"
			fi

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
		exeinto /usr/$(get_libdir)/chromium-browser/PepperFlash
		doexe usr/${pkglibdir}/flash-plugin/libpepflashplayer.so
		insinto /usr/$(get_libdir)/chromium-browser/PepperFlash
		doins usr/${pkglibdir}/flash-plugin/manifest.json

		if multilib_is_native_abi; then
			dodir /etc/chromium
			sed "${FILESDIR}"/pepper-flash \
				-e "s|@FP_LIBDIR@|$(get_libdir)|g" \
				-e "s|@FP_PV@|${PV}|g" \
				> "${D}"/etc/chromium/pepper-flash \
				|| die
		fi
	fi
}
