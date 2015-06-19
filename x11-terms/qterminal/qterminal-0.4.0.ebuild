# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/qterminal/qterminal-0.4.0.ebuild,v 1.4 2014/06/08 12:42:02 mrueg Exp $

EAPI="4"

inherit cmake-utils

DESCRIPTION="Qt4-based multitab terminal emulator"
HOMEPAGE="https://github.com/qterminal/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="dev-qt/qtgui:4
	x11-libs/qtermwidget"
RDEPEND="${DEPEND}"

#todo: translations
