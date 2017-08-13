# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KDE_LINGUAS="cs da de es et fi fr it mr nl pl pt pt_BR ru sk sl sv tr uk"
inherit kde4-base

DESCRIPTION="Alternative to KDE4 Plasma notifications"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=117147"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	kde-frameworks/kdelibs:4[plasma(+)]
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND=${DEPEND}
