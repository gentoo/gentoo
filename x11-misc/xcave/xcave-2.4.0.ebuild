# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcave/xcave-2.4.0.ebuild,v 1.3 2013/05/11 07:35:41 patrick Exp $

EAPI=4

DESCRIPTION="View and manage contents of your wine cellar"
HOMEPAGE="http://xcave.free.fr/index-en.php"
SRC_URI="http://${PN}.free.fr/backbone.php?what=download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND=">=x11-libs/gtk+-2.8:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/intltool"

src_install() {
	default
	dodoc ChangeLog TODO
	rm -rfv "${D}"/usr/doc
}
