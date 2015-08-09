# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_P=${P/qlandkartegt-/}

inherit cmake-utils

DESCRIPTION="Garmin drivers for qlandkartegt"
HOMEPAGE="http://www.qlandkarte.org/"
SRC_URI="mirror://sourceforge/qlandkartegt/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/libusb:0
	sci-geosciences/qlandkartegt
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
