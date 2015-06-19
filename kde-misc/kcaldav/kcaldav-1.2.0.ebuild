# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kcaldav/kcaldav-1.2.0.ebuild,v 1.5 2014/03/20 22:03:00 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="CalDAV support plugin for KDE Kontact"
HOMEPAGE="http://code.google.com/p/kcaldav/"
SRC_URI="http://kcaldav.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/libcaldav"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-unbundle.patch" )

S=${WORKDIR}/${P}/src

src_configure() {
	mycmakeargs=( -DKCALDAV_VERSION=${PV} )
	kde4-base_src_configure
}
