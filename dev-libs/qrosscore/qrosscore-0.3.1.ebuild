# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="KDE-free version of Kross (core libraries and Qt Script backend)"
HOMEPAGE="https://github.com/0xd34df00d/Qross"
SRC_URI="https://github.com/0xd34df00d/Qross/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/designer:4
	dev-qt/qtscript:4
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/Qross-${PV}/src/qross"
