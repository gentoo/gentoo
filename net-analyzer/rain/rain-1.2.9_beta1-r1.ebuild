# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

MY_P=${P/_/}
MY_P=${MY_P/-/_}
DESCRIPTION="powerful tool for testing stability of utilizing IP protocols"
HOMEPAGE="http://www.mirrors.wiretapped.net/security/packet-construction/rain/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
SRC_URI="
	mirror://ubuntu/pool/universe/r/${PN}/${MY_P}.orig.tar.gz
	mirror://ubuntu/pool/universe/r/${PN}/${MY_P}-1.diff.gz
"

DOCS=( BUGS CHANGES README TODO )
S="${WORKDIR}/${MY_P/_/-}"
PATCHES=(
	"${WORKDIR}"/${MY_P}-1.diff
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-die-on-error.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default
	gunzip "${ED}"/usr/share/man/man1/${PN}.1.gz || die
}
