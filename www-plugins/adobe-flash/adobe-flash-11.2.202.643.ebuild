# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit nsplugins toolchain-funcs versionator multilib multilib-minimal

DESCRIPTION="Adobe Flash Player"
HOMEPAGE="
	http://www.adobe.com/products/flashplayer.html
	http://get.adobe.com/flashplayer/
	https://helpx.adobe.com/security/products/flash-player.html
"

AF_URI="http://fpdownload.macromedia.com/get/flashplayer/pdc"
AF_DB_URI="http://fpdownload.macromedia.com/pub/flashplayer/updaters"
PV_M=$(get_major_version)
AF_32_URI="${AF_URI}/${PV}/install_flash_player_${PV_M}_linux.i386.tar.gz -> ${P}.i386.tar.gz"
AF_64_URI="${AF_URI}/${PV}/install_flash_player_${PV_M}_linux.x86_64.tar.gz -> ${P}.x86_64.tar.gz"
AF_32_DB_URI="${AF_DB_URI}/${PV_M}/flashplayer_${PV_M}_plugin_debug.i386.tar.gz -> ${P}-debug.i386.tar.gz"

SRC_URI="
	abi_x86_32? (
		!debug? ( ${AF_32_URI} )
		debug? ( ${AF_32_DB_URI} )
	)
	abi_x86_64? ( ${AF_64_URI} )
"
IUSE="debug kde selinux cpu_flags_x86_sse2"
REQUIRED_USE="
	cpu_flags_x86_sse2
	debug? ( abi_x86_32 )
	|| ( abi_x86_64 abi_x86_32 )
"
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="AdobeFlash-11.x"
RESTRICT="strip mirror"

S="${WORKDIR}"

NATIVE_DEPS="
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	kde? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
		kde-base/kdelibs
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXpm
	)
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

DEPEND="
	amd64? ( abi_x86_32? ( !abi_x86_64? ( www-plugins/nspluginwrapper ) ) )
"
RDEPEND="
	${DEPEND}
	abi_x86_64? ( ${NATIVE_DEPS} )
	abi_x86_32? (
		amd64? (
			>=dev-libs/atk-2.10.0[abi_x86_32(-)]
			>=dev-libs/glib-2.34.3:2[abi_x86_32(-)]
			>=dev-libs/nspr-4.10.4[abi_x86_32(-)]
			>=dev-libs/nss-3.15.4[abi_x86_32(-)]
			>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
			>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
			>=x11-libs/cairo-1.12.14-r4[abi_x86_32(-)]
			>=x11-libs/gdk-pixbuf-2.30.7[abi_x86_32(-)]
			>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
			>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
			>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
			>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
			>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
			>=x11-libs/libXt-1.1.4[abi_x86_32(-)]
			>=x11-libs/pango-1.36.3[abi_x86_32(-)]
		)
		x86? ( ${NATIVE_DEPS} )
	)
	|| ( media-fonts/liberation-fonts media-fonts/corefonts )
	selinux? ( sec-policy/selinux-flash )
"

# Ignore QA warnings in these closed-source binaries, since we can't fix them:
QA_PREBUILT="usr/*"

any_cpu_missing_flag() {
	local value=${1}
	grep '^flags' /proc/cpuinfo | grep -qv "${value}"
}

pkg_setup() {
	unset need_lahf_wrapper
	if use abi_x86_64 && any_cpu_missing_flag 'lahf_lm'; then
		export need_lahf_wrapper=1
	fi
}

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

src_configure() { :; }

multilib_src_compile() {
	if [[ ${ABI} == amd64 && ${need_lahf_wrapper} ]]; then
		# This experimental wrapper, from Maks Verver via bug #268336 should
		# emulate the missing lahf instruction affected platforms.
		set -- $(tc-getCC) -fPIC -shared -nostdlib -lc \
			-oflashplugin-lahf-fix.so  "${FILESDIR}/flashplugin-lahf-fix.c"
		echo "${@}" >&2
		"${@}" || die "Compile of flashplugin-lahf-fix.so failed"
	fi
}

multilib_src_install() {
	# PLUGINS_DIR comes from nsplugins.eclass
	exeinto /usr/$(get_libdir)/${PLUGINS_DIR}
	doexe libflashplayer.so

	if [[ ${ABI} == amd64 && ${need_lahf_wrapper} ]]; then
		# This experimental wrapper, from Maks Verver via bug #268336 should
		# emulate the missing lahf instruction affected platforms.
		doexe flashplugin-lahf-fix.so
	fi

	if multilib_is_native_abi; then
		if use kde; then
			local pkglibdir=lib
			[[ -d usr/lib64 ]] && pkglibdir=lib64

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
}

unregister_pluginwrapper() {
	# TODO: Perhaps parse the output of 'nspluginwrapper -l'
	# TODO: However, the 64b flash plugin makes
	# TODO: 'nspluginwrapper -l' segfault.
	local FLASH_WRAPPER="${ROOT}/usr/lib64/${PLUGINS_DIR}/npwrapper.libflashplayer.so"
	if has_version 'www-plugins/nspluginwrapper' && [[ -f ${FLASH_WRAPPER} ]]; then
		einfo "Removing 32-bit plugin wrapper"
		nspluginwrapper -r "${FLASH_WRAPPER}"
	fi
}

pkg_postinst() {
	if use amd64 ; then
		if [[ ${need_lahf_wrapper} ]]; then
			ewarn "Your processor does not support the 'lahf' instruction which is used"
			ewarn "by Adobe's 64-bit flash binary. We have installed a wrapper which"
			ewarn "should allow this plugin to run. If you encounter problems, please"
			ewarn "adjust your USE flags to install only the 32-bit version and reinstall:"
			ewarn " ${CATEGORY}/${PN}[abi_x86_32,-abi_x86_64]"
			elog
		fi
		# needed to clean up upgrades from older installs
		if use abi_x86_64 && [[ -n ${REPLACING_VERSIONS} ]]; then
			unregister_pluginwrapper
		fi
		if has_version 'www-plugins/nspluginwrapper'; then
			if use abi_x86_32 && ! use abi_x86_64; then
				einfo "nspluginwrapper detected: Installing plugin wrapper"
				local oldabi="${ABI}"
				ABI="x86"
				local FLASH_SOURCE="${ROOT}/usr/lib32/${PLUGINS_DIR}/libflashplayer.so"
				nspluginwrapper -i "${FLASH_SOURCE}"
				ABI="${oldabi}"
			fi
		elif use abi_x86_32; then
			elog "To use the 32-bit flash player in a native 64-bit browser,"
			elog "you must install www-plugins/nspluginwrapper"
		fi
	fi
}

pkg_prerm() {
	use amd64 && use abi_x86_32 && ! use abi_x86_64 && \
		unregister_pluginwrapper
}
