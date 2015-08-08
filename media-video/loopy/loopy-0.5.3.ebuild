# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="cs de hu pt_BR"
inherit kde4-base

MY_P=${P/-/_}

DESCRIPTION="Simple video player for KDE"
HOMEPAGE="http://www.kde-apps.org/content/show.php/Loopy?content=120880"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/120880-${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}

DOCS=( THEMING )
