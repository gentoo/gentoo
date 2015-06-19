# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpri/libpri-1.4.12-r2.ebuild,v 1.3 2012/02/16 17:54:33 phajdan.jr Exp $

EAPI="4"

inherit base

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Primary Rate ISDN (PRI) library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/${PN}/releases/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~sparc x86"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.12-multilib.patch"
	"${FILESDIR}/${PN}-1.4.12-respect-user-flags.patch"
)

src_install() {
	emake INSTALL_PREFIX="${D}" LIBDIR="${D}/usr/$(get_libdir)" install
	use static-libs || find "${D}" -name '*.a' -delete
	dodoc ChangeLog README TODO
}
