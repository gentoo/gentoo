# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Algorithms for RAW processing from RawTherapee"
HOMEPAGE="https://github.com/CarVac/librtprocess/"
SRC_URI="https://github.com/CarVac/librtprocess/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
