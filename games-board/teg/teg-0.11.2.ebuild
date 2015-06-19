# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/teg/teg-0.11.2.ebuild,v 1.6 2015/01/08 09:10:38 tupone Exp $

EAPI=5
inherit gnome2

DESCRIPTION="Gnome Risk Clone"
HOMEPAGE="http://teg.sourceforge.net/"
SRC_URI="mirror://sourceforge/teg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="nls"

RDEPEND="dev-libs/glib:2
	gnome-base/libgnomeui
	gnome-base/libgnome
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-text/htmltidy
	nls? ( sys-devel/gettext )"
