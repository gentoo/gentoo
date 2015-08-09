# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils

DESCRIPTION="A simple SMS tool"
HOMEPAGE="http://www.kde-apps.org/content/show.php/past+-+SMS+Tool?content=74036"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/74036-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	app-mobilephone/gnokii[sms]"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog TODO )
PATCHES=( "${FILESDIR}/${P}-gcc-4.7.patch" )
