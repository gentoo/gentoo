# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrar-gpl/unrar-gpl-0.0.1_p20080417-r1.ebuild,v 1.3 2013/05/18 14:58:08 jer Exp $

EAPI=4
inherit autotools

DESCRIPTION="Free rar unpacker for old (pre v3) rar files"
HOMEPAGE="http://home.gna.org/unrar/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS="AUTHORS README"

S=${WORKDIR}/${PN/-gpl}

src_prepare() {
	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf
}
src_configure() { econf --program-suffix="-gpl"; }
