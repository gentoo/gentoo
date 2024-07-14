# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="a fast cryptographic hash function"
HOMEPAGE="https://github.com/BLAKE3-team/BLAKE3"
SRC_URI="https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/BLAKE3-${PV}/c"

LICENSE="|| ( CC0-1.0 Apache-2.0 )"
SLOT="0/0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
