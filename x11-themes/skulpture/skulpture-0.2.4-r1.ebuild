# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Classical style and window decorations for KDE"
HOMEPAGE="http://skulpture.maxiom.de/"
SRC_URI="http://kde-look.org/CONTENT/content-files/59031-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="$(add_kdebase_dep kwin)"
RDEPEND="${DEPEND}"
