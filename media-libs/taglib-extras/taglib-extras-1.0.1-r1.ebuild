# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Unofficial taglib plugins maintained by the Amarok team"
HOMEPAGE="https://websvn.kde.org/trunk/kdesupport/taglib-extras/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="debug"

RDEPEND="
	>=media-libs/taglib-1.6
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog )
PATCHES=( "${FILESDIR}/${P}-taglib110.patch" )
