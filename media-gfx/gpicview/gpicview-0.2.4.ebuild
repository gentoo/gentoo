# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gpicview/gpicview-0.2.4.ebuild,v 1.6 2015/03/03 08:18:02 dlan Exp $

EAPI=4

DESCRIPTION="A Simple and Fast Image Viewer for X"
HOMEPAGE="http://lxde.sourceforge.net/gpicview"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86 ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/jpeg
	>=x11-libs/gtk+-2.6:2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS
}
