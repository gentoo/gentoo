# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="4c613505b2cb"
DESCRIPTION="Utility to convert hex or dec to binary format"
HOMEPAGE="https://bitbucket.org/PascalRD/i2bits/"
SRC_URI="https://bitbucket.org/PascalRD/i2bits/get/${COMMIT}.tar.gz -> ${P}-bb.tar.gz"
S="${WORKDIR}/PascalRD-${PN}-${COMMIT}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-cmake4.patch" )
