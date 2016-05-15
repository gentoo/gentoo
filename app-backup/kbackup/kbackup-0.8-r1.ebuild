# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KDE_LINGUAS="cs de es fr it pt pt_BR ru sk sv"
inherit kde4-base

DESCRIPTION="KBackup is a program that lets you back up any directories or files"
HOMEPAGE="http://kde-apps.org/content/show.php/KBackup?content=44998"
SRC_URI="http://members.aon.at/m.koller/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"
