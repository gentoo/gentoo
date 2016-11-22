# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A pomodoro app that blocks distractions while you work"
HOMEPAGE="https://github.com/iamsergio/flow-pomodoro"
SRC_URI="https://github.com/iamsergio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
