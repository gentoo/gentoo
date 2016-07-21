# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="turns your Realtek RTL2832 based DVB dongle into a SDR receiver"
HOMEPAGE="http://sdr.osmocom.org/trac/wiki/rtl-sdr"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

DOCS=( ${PN}.rules )

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	sed -i "s:pkgdocdir:docdir:g" Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --docdir="/usr/share/doc/${PF}"
}

pkg_postinst() {
	local rulesfiles=( "${EPREFIX}"/etc/udev/rules.d/*${PN}.rules )
	if [[ ! -f ${rulesfiles} ]]; then
		elog "By default, only users in the usb group can capture."
		elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
		elog "Or the device can be WORLD readable and writable by installing ${PN}.rules"
		elog "from the documentation directory to ${EPREFIX}/etc/udev/rules.d/"
	fi
}
