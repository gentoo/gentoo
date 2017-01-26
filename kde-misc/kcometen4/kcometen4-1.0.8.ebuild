# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OPENGL_REQUIRED="always"
KDE_MINIMAL="4.10.3"
inherit kde4-base

HOMEPAGE="http://www.kde-apps.org/content/show.php?content=87586"
DESCRIPTION="OpenGL KDE4 screensaver"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/87586-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	kde-plasma/kscreensaver:4
	media-libs/libart_lgpl
	virtual/glu
	virtual/opengl
"
RDEPEND="${DEPEND}"
