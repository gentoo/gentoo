# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/knights/knights-2.5.0-r1.ebuild,v 1.5 2015/06/04 19:02:46 kensington Exp $

EAPI=5

KDE_MINIMAL="4.9"
KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl it km lt nb nds nl
nn pl pt pt_BR ru sr sr@ijekavian sr@ijekavianlatin sr@latin sv uk zh_TW"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Simple chess board for KDE"
HOMEPAGE="http://kde-apps.org/content/show.php/Knights?content=122046"
SRC_URI="http://dl.dropbox.com/u/2888238/Knights/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep libkdegames)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

pkg_postinst() {
	kde4-base_pkg_postinst

	elog "No chess engines are emerged by default! If you want a chess engine"
	elog "to play with, you can emerge gnuchess or crafty."
}
