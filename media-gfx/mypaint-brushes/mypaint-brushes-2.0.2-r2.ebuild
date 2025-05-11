# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Default MyPaint brushes"
HOMEPAGE="https://github.com/mypaint/mypaint-brushes"
SRC_URI="https://github.com/mypaint/mypaint-brushes/releases/download/v${PV}/${P}.tar.xz"

LICENSE="CC0-1.0"
SLOT="2.0" # due to pkgconfig name "mypaint-brushes-2.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv x86"
