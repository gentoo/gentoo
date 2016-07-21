# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Mozilla LDAP C SDK"
HOMEPAGE="http://www.port389.org/"
SRC_URI="http://www.port389.org/binaries/${P}.tar.bz2"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/nss-3.11
	>=dev-libs/nspr-4.6"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-4.1-gentoo.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	# cope with libraries being in /usr/lib/svrcore
	echo "LDPATH='/usr/$(get_libdir)/${PN}'" > "${T}/08svrcore" || die "Unable to create env file"
	doenvd "${T}/08svrcore"
}
