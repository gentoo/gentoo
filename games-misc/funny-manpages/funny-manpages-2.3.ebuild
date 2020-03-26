# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_R="${PV:0-1}"
MY_P="${PN}_${PV/_p?/}"
DESCRIPTION="funny manpages collected from various sources"
HOMEPAGE="https://www.debian.org/"
SRC_URI="mirror://debian/pool/main/f/funny-manpages/${MY_P}.orig.tar.gz"

if [[ "${PV}" = *_p* ]] ; then
	SRC_URI+=" mirror://debian/pool/main/f/funny-manpages/${MY_P}-${MY_R}.diff.gz"
fi

LICENSE="freedist" #465704
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc64 ~s390 ~x86"
IUSE=""

RDEPEND="virtual/man"

S="${WORKDIR}/${PN}/man"

src_prepare() {
	if [[ "${PV}" = *_p* ]] ; then
		eapply "${WORKDIR}"/${MY_P}-${MY_R}.diff
	fi

	eapply_user

	for f in *.[0-57-9]fun ; do
		mv ${f} ${f/.?fun/.6fun} || die "renaming ${f} failed"
	done
}

src_install() {
	doman *.6fun
}
