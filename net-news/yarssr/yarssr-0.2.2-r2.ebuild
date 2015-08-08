# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Yet Another RSS Reader - A KDE/Gnome system tray rss aggregator"
HOMEPAGE="http://yarssr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/Locale-gettext
		dev-perl/XML-RSS
		dev-perl/gtk2-trayicon
		dev-perl/gtk2-gladexml
		dev-perl/gnome2-vfs-perl
		>=dev-perl/gnome2-perl-0.94"

DOCS=( ChangeLog TODO README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-cve-2007-5837.patch
}
