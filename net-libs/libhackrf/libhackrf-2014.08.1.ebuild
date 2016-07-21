# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils udev

DESCRIPTION="library for communicating with HackRF SDR platform"
HOMEPAGE="http://greatscottgadgets.com/hackrf/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mossmann/hackrf.git"
	inherit git-2
	KEYWORDS=""
	EGIT_SOURCEDIR="${WORKDIR}/hackrf"
	S="${WORKDIR}/hackrf/host/libhackrf"
else
	S="${WORKDIR}/hackrf-${PV}/host/libhackrf"
	SRC_URI="mirror://sourceforge/hackrf/hackrf-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's#plugdev#usb#' 53-hackrf.rules
}

src_install() {
	cmake-utils_src_install
	udev_dorules 53-hackrf.rules
}

pkg_postinst() {
	einfo "Users in the usb group can use hackrf."
}
