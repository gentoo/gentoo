# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility for viewing/manipulating the MAC address of network interfaces"
OUI_DATE="20091029" # Generated with tools/IEEE_OUI.py in the source
OUI_FILE="OUI.list-${OUI_DATE}"
HOMEPAGE="https://github.com/alobbs/macchanger"
SRC_URI="
	https://github.com/alobbs/macchanger/releases/download/${PV/_p*}/${P/_p*}.tar.gz
	mirror://debian/pool/main/m/${PN}/${PN}_${PV/_p*}-$(ver_cut 5).$(ver_cut 7).debian.tar.xz
"
LICENSE="GPL-2"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"
SLOT="0"
IUSE="split-usr"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-fix-caddr_t.patch
	"${WORKDIR}"/debian/patches/02-fix_usage_message.patch
	"${WORKDIR}"/debian/patches/06-update_OUI_list.patch
	"${WORKDIR}"/debian/patches/08-fix_random_MAC_choice.patch
	"${WORKDIR}"/debian/patches/check-random-device-read-errors.patch
	"${WORKDIR}"/debian/patches/verify-changed-MAC.patch

)
S=${WORKDIR}/${P/_p*}

src_configure() {
	# Shared data is installed below /lib, see Bug #57046
	econf \
		--bindir="${EPREFIX}/sbin" \
		--datadir="${EPREFIX}/lib"
}

src_install() {
	default

	newdoc "${WORKDIR}"/debian/changelog debian.changelog

	# Can cleanup a while after bug #889922 is fixed
	if use split-usr ; then
		dodir /usr/bin
		dosym -r /sbin/macchanger /usr/bin/macchanger
	fi

	dosym ../../lib/macchanger /usr/share/macchanger
}
