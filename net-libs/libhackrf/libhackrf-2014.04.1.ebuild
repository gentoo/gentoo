# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libhackrf/libhackrf-2014.04.1.ebuild,v 1.1 2014/05/01 14:41:41 zerochaos Exp $

EAPI=5

inherit cmake-utils

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
