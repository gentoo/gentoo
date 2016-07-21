# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit gnustep-2

DESCRIPTION="A workspace manager for GNUstep"
HOMEPAGE="http://www.gnustep.org/experience/GWorkspace.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/${P}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"

IUSE=""

# GWMetadata compilation broken for now
#DEPEND=">=gnustep-apps/systempreferences-1.0.1_p24791
#	>=dev-db/sqlite-3.2.8"
#RDEPEND="${DEPEND}"

src_configure() {
	local myconf=""
	use kernel_linux && myconf="${myconf} --with-inotify"

	egnustep_env
	econf --disable-gwmetadata ${myconf}
}

src_install() {
	egnustep_env
	egnustep_install

	if use doc;
	then
		dodir /usr/share/doc/${PF}
		cp "${S}"/Documentation/*.pdf "${D}"/usr/share/doc/${PF}
	fi
}
