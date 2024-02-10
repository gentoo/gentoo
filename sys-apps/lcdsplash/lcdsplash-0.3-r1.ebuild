# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="splash Gentoo boot information on LCD's"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~vapier/dist/${P}.tar.bz2
"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="hppa ~mips x86"

RDEPEND="mips? ( sys-apps/lcdutils )"

src_install() {
	insinto /sbin
	doins splash-functions.sh

	insinto /$(get_libdir)/rcscripts/lcdsplash
	doins -r modules/.

	insinto /etc
	doins lcdsplash.conf

	einstalldocs
}
