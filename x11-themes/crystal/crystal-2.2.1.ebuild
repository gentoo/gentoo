# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_MINIMAL="4.9"
inherit kde4-base

DESCRIPTION="Crystal decoration theme for KDE4.x"
HOMEPAGE="http://kde-look.org/content/show.php/Crystal?content=75140"
SRC_URI="http://kde-look.org/CONTENT/content-files/75140-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="kde-plasma/kwin:4"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README.md )
