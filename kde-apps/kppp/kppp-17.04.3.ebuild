# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="A dialer and front-end to pppd"
HOMEPAGE="https://www.kde.org/applications/internet/kppp"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	net-dialup/ppp
"
