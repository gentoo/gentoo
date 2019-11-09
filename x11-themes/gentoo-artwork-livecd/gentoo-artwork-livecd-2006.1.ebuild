# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of Gentoo Linux wallpapers for the LiveCD"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~wolf31o2/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc x86"
IUSE=""
RESTRICT="binchecks strip"

S=${WORKDIR}

src_install() {
	insinto /usr/share/pixmaps
	doins -r *
}
