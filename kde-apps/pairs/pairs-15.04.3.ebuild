# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="never"
inherit kde4-base

DESCRIPTION="KDE memory and pairs game"
HOMEPAGE="https://edu.kde.org/applications/miscellaneous/pairs"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${P}.tar.xz"

KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"
