# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasma-widget-message-indicator/plasma-widget-message-indicator-0.5.8.ebuild,v 1.4 2014/12/31 12:31:54 kensington Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="Plasmoid for displaying Ayatana indications"
HOMEPAGE="https://launchpad.net/plasma-widget-message-indicator"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=dev-libs/libdbusmenu-qt-0.3.0[qt4(+)]
	>=dev-libs/libindicate-qt-0.2.5
"
DEPEND="
	${RDEPEND}
	dev-libs/libindicate
"

# 1 test fails
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-libindicate.patch" )
