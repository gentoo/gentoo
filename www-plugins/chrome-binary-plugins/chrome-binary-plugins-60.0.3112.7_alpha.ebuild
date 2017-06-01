# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

SRC_URI="https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb"
KEYWORDS="-* ~amd64"

LICENSE="google-chrome"
IUSE="+widevine"
RESTRICT="bindist mirror strip"

RDEPEND="widevine? ( !<www-client/chromium-57[widevine(-)] )"

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
	insinto /usr/$(get_libdir)/chromium
	if use widevine; then
		doins libwidevinecdm.so libwidevinecdmadapter.so
		dosym ../chromium/libwidevinecdm.so /usr/$(get_libdir)/chromium-browser/libwidevinecdm.so
		dosym ../chromium/libwidevinecdmadapter.so /usr/$(get_libdir)/chromium-browser/libwidevinecdmadapter.so
	fi
}
