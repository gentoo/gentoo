# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_MINIMAL="4.8"
KDE_LINGUAS="ca de es el gl it pl ru tr"
KDE_LINGUAS_DIR="translations"
inherit kde4-base

DESCRIPTION="A tablet desktop style app launcher"
HOMEPAGE="http://code.google.com/p/takeoff-launcher/"
SRC_URI="https://takeoff-launcher.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="$(add_kdebase_dep plasma-workspace)"
RDEPEND="${DEPEND}"
