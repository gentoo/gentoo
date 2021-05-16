# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_R=${PV:0-1}
MY_P=${PN}_${PV/_rc?/}
DESCRIPTION="Funny manpages collected from various sources"
HOMEPAGE="https://www.debian.org/"
SRC_URI="mirror://debian/pool/main/f/funny-manpages/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/f/funny-manpages/${MY_P}-${MY_R}.diff.gz"
S="${WORKDIR}"/${MY_P/_/-}.orig

LICENSE="freedist" #465704
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc64 ~s390 ~x86"

RDEPEND="virtual/man"

PATCHES=(
	"${WORKDIR}"/${MY_P}-${MY_R}.diff
)

src_prepare() {
	default

	for f in *.[0-57-9]fun ; do
		mv ${f} ${f/.?fun/.6fun} || die "renaming ${f} failed"
	done
}

src_install() {
	doman *.6fun
}
