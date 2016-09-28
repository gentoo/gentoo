# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="LXDE Task manager"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~arm-linux ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

# Upstream report:
# https://sourceforge.net/p/lxde/patches/535/
PATCHES=( "${FILESDIR}/lxtask-0.1.7-fix-no-common.patch" )

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README
}
