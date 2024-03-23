# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

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

KEYWORDS="-* ~amd64"

MY_PN="google-chrome-${SLOT}"
MY_P="${MY_PN}_${MY_PV}"

SRC_URI="https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb"

LICENSE="google-chrome"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	sys-libs/glibc
"

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
	insinto "/usr/$(get_libdir)/chromium-browser"
	doins -r WidevineCdm
}
