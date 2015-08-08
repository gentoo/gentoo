# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="mpdnowplaying"
MY_P=${MY_PN}-${PV}
KDE_LINGUAS="de pt_BR ru"
inherit kde4-base

DESCRIPTION="Plasmoid attached to MPD displaying currently played item"
HOMEPAGE="http://kde-look.org/content/show.php/MPD+Now+Playing?content=132350"
SRC_URI="http://kde-look.org/CONTENT/content-files/132350-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="media-libs/libmpdclient"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_PN}
