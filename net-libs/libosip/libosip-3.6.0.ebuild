# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils autotools

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

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.3.0-out-source-build.patch"
	AT_M4DIR="scripts" eautoreconf
}

src_configure() {
	econf --enable-mt \
		$(use_enable test)
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install"
	dodoc AUTHORS ChangeLog FEATURES HISTORY README NEWS TODO || die
}
