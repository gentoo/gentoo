# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="automatically update your pidgin profile with current info from Rhythmbox"
HOMEPAGE="http://jon.oberheide.org/pidgin-rhythmbox/"
SRC_URI="http://jon.oberheide.org/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

RDEPEND="net-im/pidgin
	media-sound/rhythmbox
	>=x11-libs/gtk+-2.4:2
	dev-libs/dbus-glib"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
