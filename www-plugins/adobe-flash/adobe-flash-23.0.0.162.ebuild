# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib multilib-minimal

DESCRIPTION="Adobe Flash Player"
HOMEPAGE="
	http://www.adobe.com/products/flashplayer.html
	http://get.adobe.com/flashplayer/
	https://helpx.adobe.com/security/products/flash-player.html
"

AF_URI="https://fpdownload.adobe.com/pub/flashplayer/pdc"
AF_32_URI="${AF_URI}/${PV}/flash_player_ppapi_linux.i386.tar.gz -> ${P}.i386.tar.gz"
AF_64_URI="${AF_URI}/${PV}/flash_player_ppapi_linux.x86_64.tar.gz -> ${P}.x86_64.tar.gz"

SRC_URI="
	abi_x86_32? ( ${AF_32_URI} )
	abi_x86_64? ( ${AF_64_URI} )
"
SLOT="22"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="AdobeFlash-11.x"
RESTRICT="strip mirror"

RDEPEND="
	!www-plugins/chrome-binary-plugins[flash]
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
	exeinto /usr/$(get_libdir)/chromium-browser/PepperFlash
	doexe libpepflashplayer.so
	insinto /usr/$(get_libdir)/chromium-browser/PepperFlash
	doins manifest.json

	if multilib_is_native_abi; then
		dodir /etc/chromium
		sed "${FILESDIR}"/pepper-flash \
			-e "s|@FP_LIBDIR@|$(get_libdir)|g" \
			-e "s|@FP_PV@|${PV}|g" \
			> "${D}"/etc/chromium/pepper-flash \
			|| die
	fi
}
