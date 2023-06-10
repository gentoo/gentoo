# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility for generating icon themes and libXcursor cursor themes"
HOMEPAGE="https://www.freedesktop.org/software/icon-slicer/"
SRC_URI="https://www.freedesktop.org/software/icon-slicer/releases/${P}.tar.gz"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="x11-apps/xcursorgen
	x11-libs/gtk+:2
	dev-libs/popt"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
