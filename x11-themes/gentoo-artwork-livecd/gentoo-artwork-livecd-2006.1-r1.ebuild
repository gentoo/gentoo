# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A collection of Gentoo Linux wallpapers for the LiveCD"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~wolf31o2/sources/${PN}/${P}.tar.bz2"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"

RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/pixmaps
	doins -r *
}
