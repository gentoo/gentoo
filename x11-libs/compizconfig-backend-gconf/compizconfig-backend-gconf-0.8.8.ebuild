# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/compizconfig-backend-gconf/compizconfig-backend-gconf-0.8.8.ebuild,v 1.1 2012/08/30 17:06:13 pinkbyte Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Compizconfig Gconf Backend"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=gnome-base/gconf-2.0:2
	>=x11-libs/libcompizconfig-${PV}
	>=x11-wm/compiz-${PV}
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	default
	prune_libtool_files
}
