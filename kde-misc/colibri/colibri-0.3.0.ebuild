# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/colibri/colibri-0.3.0.ebuild,v 1.3 2013/07/04 12:25:36 ago Exp $

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
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND=${DEPEND}
