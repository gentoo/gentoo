# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/qterminal/qterminal-0.5.0_p20140913.ebuild,v 1.2 2014/09/27 11:38:55 maekke Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Qt4-based multitab terminal emulator"
HOMEPAGE="https://github.com/qterminal/qterminal"
SRC_URI="https://dev.gentoo.org/~kensington/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	x11-libs/libqxt
	>=x11-libs/qtermwidget-0.4.0.37"
RDEPEND="${DEPEND}"
