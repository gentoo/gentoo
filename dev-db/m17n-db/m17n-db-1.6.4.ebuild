# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/m17n-db/m17n-db-1.6.4.ebuild,v 1.11 2013/02/24 18:07:09 ago Exp $

EAPI=4

inherit eutils

DESCRIPTION="Database for the m17n library"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n"
SRC_URI="http://download.savannah.gnu.org/releases/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="virtual/libintl"

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
	docinto FORMATS; dodoc FORMATS/*
	docinto UNIDATA; dodoc UNIDATA/*
}
