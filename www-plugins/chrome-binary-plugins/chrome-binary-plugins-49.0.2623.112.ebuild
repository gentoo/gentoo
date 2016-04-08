# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib unpacker

DESCRIPTION="Binary plugins from Google Chrome for use in Chromium"
HOMEPAGE="https://www.google.com/chrome"

case ${PV} in
	*_alpha*)
		SLOT="unstable"
		CHROMEDIR="opt/google/chrome-${SLOT}"
		MY_PV=${PV%_alpha}-1
		;;
	*_beta*)
		SLOT="beta"
		CHROMEDIR="opt/google/chrome-${SLOT}"
		MY_PV=${PV%_beta}-1
		;;
	*)
		SLOT="stable"
		CHROMEDIR="opt/google/chrome"
		MY_PV=${PV}-1
		;;
esac

MY_PN="google-chrome-${SLOT}"
MY_P="${MY_PN}_${MY_PV}"

SRC_URI="
	amd64? (
		https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb
	)
"
KEYWORDS="-* amd64"

LICENSE="google-chrome"
IUSE="+flash +widevine"
RESTRICT="bindist mirror strip"

for x in 0 beta stable unstable; do
	if [[ ${SLOT} != ${x} ]]; then
		RDEPEND+=" !${CATEGORY}/${PN}:${x}"
	fi
done

S="${WORKDIR}/${CHROMEDIR}"
QA_PREBUILT="*"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your portage tree before reporting fetch failures."
}

src_install() {
	local version flapper

	insinto /usr/$(get_libdir)/chromium-browser/

	if use widevine; then
		doins libwidevinecdm.so
		strings ./chrome | grep -C 1 " (version:" | tail -1 > widevine.version
		doins widevine.version
	fi

	if use flash; then
		doins -r PepperFlash

		# Since this is a live ebuild, we're forced to, unfortuantely,
		# dynamically construct the command line args for Chromium.
		version=$(sed -n 's/.*"version": "\(.*\)",.*/\1/p' PepperFlash/manifest.json)
		flapper="${ROOT}usr/$(get_libdir)/chromium-browser/PepperFlash/libpepflashplayer.so"
		echo -n "CHROMIUM_FLAGS=\"\${CHROMIUM_FLAGS} " > pepper-flash
		echo -n "--ppapi-flash-path=$flapper " >> pepper-flash
		echo "--ppapi-flash-version=$version\"" >> pepper-flash

		insinto /etc/chromium/
		doins pepper-flash
	fi
}
