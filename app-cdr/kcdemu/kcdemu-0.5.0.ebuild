# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KDE_LINGUAS="de es pl ro sv"
MY_PN="kde_cdemu"

inherit kde4-base

DESCRIPTION="Frontend to cdemu daemon based on kdelibs"
HOMEPAGE="https://www.linux-apps.com/p/998461/"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/99752-${MY_PN}-${PV}.tar.bz2 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=app-cdr/cdemu-2.0.0[cdemu-daemon]"

S=${WORKDIR}/${MY_PN}

DOCS=( ChangeLog )
