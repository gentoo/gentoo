# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
