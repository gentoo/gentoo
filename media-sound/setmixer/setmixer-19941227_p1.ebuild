# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="27DEC94ds1"
DEB_REV="1"

DESCRIPTION="A commandline mixer"
HOMEPAGE="https://packages.debian.org/unstable/sound/setmixer"
SRC_URI="
	mirror://debian/pool/main/s/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/s/${PN}/${PN}_${MY_PV}-${DEB_REV}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

S="${WORKDIR}/${PN}-${MY_PV}.orig"

PATCHES=( "${WORKDIR}"/${PN}_${MY_PV}-${DEB_REV}.diff )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" setmixer
}

src_install() {
	dobin setmixer

	dodoc README setmixer.lsm
	doman setmixer.1

	insinto /etc
	doins debian/setmixer.conf

	newinitd "${FILESDIR}"/setmixer.rc setmixer
}
