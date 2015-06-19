# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync-plugin-synce-rra/libopensync-plugin-synce-rra-0.22.2.ebuild,v 1.1 2012/06/17 11:51:22 ssuominen Exp $

EAPI=4

DESCRIPTION="OpenSync SynCE RRA Plugin"
HOMEPAGE="http://sourceforge.net/projects/synce/ http://www.opensync.org/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=app-pda/libopensync-0.22*
	app-pda/synce-core
	>=dev-libs/glib-2
	>=dev-libs/librra-0.16
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
	find "${ED}" -name '*.la' -exec rm -f {} +
}
