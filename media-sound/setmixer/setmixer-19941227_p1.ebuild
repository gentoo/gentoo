# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

MY_PV="27DEC94ds1"
DEB_REV="1"

DESCRIPTION="A commandline mixer"
HOMEPAGE="http://packages.debian.org/unstable/sound/setmixer"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/s/${PN}/${PN}_${MY_PV}-${DEB_REV}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}.orig

src_unpack() {
	unpack ${A}
	epatch "${DISTDIR}"/${PN}_${MY_PV}-${DEB_REV}.diff.gz
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" setmixer || die "emake failed."
}

src_install() {
	dobin setmixer
	dodoc README setmixer.lsm
	doman setmixer.1
	insinto /etc
	doins debian/setmixer.conf
	newinitd "${FILESDIR}"/setmixer.rc setmixer
}
