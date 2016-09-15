# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE frontend for the Linux Infrared Remote Control system"
HOMEPAGE="https://www.kde.org/applications/utilities/kremotecontrol
https://utils.kde.org/projects/kremotecontrol"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-misc/lirc
"
