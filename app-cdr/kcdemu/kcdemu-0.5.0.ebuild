# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kcdemu/kcdemu-0.5.0.ebuild,v 1.3 2013/06/25 16:56:24 ago Exp $

EAPI=5
KDE_LINGUAS="de es pl ro sv"
MY_PN="kde_cdemu"

inherit kde4-base

DESCRIPTION="A frontend to cdemu daemon for KDE4"
HOMEPAGE="http://www.kde-apps.org/content/show.php/KDE+CDEmu+Manager?content=99752"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/99752-${MY_PN}-${PV}.tar.bz2 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=app-cdr/cdemu-2.0.0[cdemu-daemon]"

S=${WORKDIR}/${MY_PN}

DOCS=( ChangeLog )
