# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils git-r3 qmake-utils

DESCRIPTION="Qt-based clone of Stamina - the touch typing tutor program"
HOMEPAGE="https://github.com/zeal18/qstamina"
EGIT_REPO_URI="git://github.com/zeal18/qstamina.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/qstamina-stamina.patch"
	epatch "${FILESDIR}/qstamina-src.patch"
	default
}

src_configure() {
	eqmake5
}

S="${WORKDIR}/${P}/src"
