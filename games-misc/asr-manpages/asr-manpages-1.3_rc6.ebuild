# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

MY_R="6"
MY_P="${PN}_${PV/_rc6/}"
DESCRIPTION="set of humorous manual pages developed on alt.sysadmin.recovery"
HOMEPAGE="https://www.debian.org"
SRC_URI="mirror://debian/pool/main/a/asr-manpages/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/asr-manpages/${MY_P}-${MY_R}.diff.gz"

LICENSE="freedist" #465704
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc64 ~s390 ~x86"
IUSE=""

RDEPEND="virtual/man"

S=${WORKDIR}/${MY_P/_/-}.orig

src_prepare() {
	epatch ../"${MY_P}-${MY_R}.diff"
	rm -rf debian
}

src_install() {
	doman *
}
