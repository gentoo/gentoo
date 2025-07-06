# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Verifies the integrity of PNG, JNG, and MNG files with internal checksums"
HOMEPAGE="https://www.libpng.org/pub/png/apps/pngcheck.html https://github.com/pnggroup/pngcheck"
SRC_URI="https://github.com/pnggroup/pngcheck/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="HPND GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
