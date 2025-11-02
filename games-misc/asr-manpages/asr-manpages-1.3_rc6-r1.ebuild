# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_R="6"
MY_P="${PN}_${PV/_rc6/}"
DESCRIPTION="Set of humorous manual pages developed on alt.sysadmin.recovery"
HOMEPAGE="https://www.debian.org"
SRC_URI="https://archive.debian.org/debian/pool/main/a/${PN}/${MY_P}.orig.tar.gz
	https://archive.debian.org/debian/pool/main/a/${PN}/${MY_P}-${MY_R}.diff.gz"
S="${WORKDIR}"/${MY_P/_/-}.orig

LICENSE="freedist" #465704
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~m68k ~mips ~ppc64 ~s390 ~x86"

RDEPEND="virtual/man"

PATCHES=(
	"${WORKDIR}"/${MY_P}-${MY_R}.diff
)

src_prepare() {
	default
	rm -rf debian || die
}

src_install() {
	doman *
}
