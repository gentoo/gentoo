# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Unofficial taglib plugins maintained by the Amarok team"
HOMEPAGE="https://websvn.kde.org/trunk/kdesupport/taglib-extras/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND="media-libs/taglib"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-taglib110.patch" ) # bug 571072
