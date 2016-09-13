# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="LXDE GUI interface to RandR extention"
HOMEPAGE="http://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86 ~arm-linux ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXrandr
	x11-apps/xrandr"
DEPEND="${RDEPEND}
	x11-proto/randrproto
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS
}
