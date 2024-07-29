# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN=EDIM
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Elementary Divisors of Integer Matrices (EDIM) for GAP"
SRC_URI="https://www.math.rwth-aachen.de/~Frank.Luebeck/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/gap:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.7-user-flags.patch"
)

gap-pkg_enable_tests
