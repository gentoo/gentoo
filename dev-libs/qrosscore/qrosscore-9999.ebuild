# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qrosscore/qrosscore-9999.ebuild,v 1.6 2014/08/10 20:39:11 slyfox Exp $

EAPI=5

EGIT_REPO_URI="git://github.com/0xd34df00d/Qross.git"

inherit cmake-utils git-r3

DESCRIPTION="KDE-free version of Kross (core libraries and Qt Script backend)"
HOMEPAGE="http://github.com/0xd34df00d/Qross"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/designer:4
	dev-qt/qtscript:4
"
DEPEND="${RDEPEND}"

CMAKE_USE_DIR="${S}/src/qross"
