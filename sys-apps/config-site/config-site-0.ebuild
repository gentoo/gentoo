# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="config.site to load dropins from config.site.d"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="!<sys-devel/crossdev-20230209-r1"

src_configure() {
	sed -e "s|@datarootdir@|${EPREFIX}/usr/share|" \
		"${FILESDIR}/config.site.in" > config.site || die
}

src_install() {
	insinto /usr/share
	doins config.site
}
