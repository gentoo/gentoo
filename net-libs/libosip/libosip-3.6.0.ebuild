# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_PV=${PV%.?}-${PV##*.}
MY_PV=${PV}
MY_P=${PN}2-${MY_PV}

DESCRIPTION="a simple way to support the Session Initiation Protocol"
HOMEPAGE="https://www.gnu.org/software/osip/"
SRC_URI="mirror://gnu/osip/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="amd64 ppc ~sparc x86 ~ppc-macos ~x86-macos"
IUSE="test"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${PN}-3.3.0-out-source-build.patch" )

src_prepare() {
	default
	AT_M4DIR="scripts" eautoreconf
}

src_configure() {
	econf --enable-mt \
		$(use_enable test)
}
