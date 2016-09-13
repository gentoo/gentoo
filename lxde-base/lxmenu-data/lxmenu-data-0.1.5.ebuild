# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Provides files needed for LXDE application menus"
HOMEPAGE="http://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README
}
