# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit bsdmk

DESCRIPTION="pidof(1) utility for *BSD"
HOMEPAGE="https://people.freebsd.org/~novel/pidof.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-freebsd/freebsd-mk-defs"
RDEPEND="!sys-process/psmisc"

S="${WORKDIR}/pidof"

PATCHES=( "${FILESDIR}/${P}-gfbsd.patch"
	"${FILESDIR}/${P}-firstarg.patch"
	"${FILESDIR}/${P}-pname.patch"
	"${FILESDIR}/${P}-fbsd11.patch" )

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_install() {
	into /
	dobin pidof
}
