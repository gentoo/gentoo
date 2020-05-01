# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Wrapper around exiv2 library"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+xmp"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=media-gfx/exiv2-0.25:=[xmp=]
"
RDEPEND="${DEPEND}"
