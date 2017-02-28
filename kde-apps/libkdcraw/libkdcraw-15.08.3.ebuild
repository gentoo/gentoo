# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="KDE digital camera raw image library wrapper"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${P}.tar.xz"

KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	>=media-libs/libraw-0.16_beta1-r1:=
"
RDEPEND="${DEPEND}"
