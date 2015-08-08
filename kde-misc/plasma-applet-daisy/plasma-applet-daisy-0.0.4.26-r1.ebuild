# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_MINIMAL="4.8"
KDE_LINGUAS_DIR="applet/po"
KDE_LINGUAS="bs de el fr hu it pl pt ru sr tr"
inherit kde4-base

DESCRIPTION="Simple application launcher for KDE 4's plasma desktop"
HOMEPAGE="http://cdlszm.org/"
SRC_URI="http://cdlszm.org/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="$(add_kdebase_dep libtaskmanager)"
RDEPEND="${DEPEND}"
