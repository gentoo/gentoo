# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="A dialer and front-end to pppd"
HOMEPAGE="https://www.kde.org/applications/internet/kppp"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	net-dialup/ppp
"
