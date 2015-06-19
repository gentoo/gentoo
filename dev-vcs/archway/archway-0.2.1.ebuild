# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/archway/archway-0.2.1.ebuild,v 1.3 2011/03/28 16:42:42 angelos Exp $

EAPI=3
inherit eutils

DESCRIPTION="A GUI for GNU Arch"
HOMEPAGE="http://www.nongnu.org/archway/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

#"ArchWay requires gtk-2.4 and gtk2-perl." -$HOMEPAGE
#DEPEND=">=dev-util/tla-1.1
#	>=dev-lang/perl-5.8.0
#	>=dev-perl/gtk2-perl-1.040
#	>=dev-perl/glib-perl-1.040
#	>=x11-libs/gtk+-2.4.0"

DEPEND=""
RDEPEND="x11-libs/gtk+:2
	>=dev-perl/gtk2-perl-1.040"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install || die
}
