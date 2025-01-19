# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="config.site to load dropins from config.site.d"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base"
SRC_URI="https://gitweb.gentoo.org/proj/config-site.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="!<sys-devel/crossdev-20230209-r1"

src_configure() {
	sed -e "s|@datarootdir@|${EPREFIX}/usr/share|" \
		config.site.in > config.site || die
}

src_install() {
	insinto /usr/share
	doins config.site
}
