# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A data compression/decompression library for embedded/real-time systems"
HOMEPAGE="https://github.com/atomicobject/heatshrink"
SRC_URI="https://github.com/atomicobject/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )
