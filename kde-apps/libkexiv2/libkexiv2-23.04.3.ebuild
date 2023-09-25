# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Wrapper around exiv2 library"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+xmp"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=media-gfx/exiv2-0.25:=[xmp=]
"
RDEPEND="${DEPEND}"
