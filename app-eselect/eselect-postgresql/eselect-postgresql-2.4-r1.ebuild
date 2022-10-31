# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility to select the default PostgreSQL slot"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~titanofold/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="app-admin/eselect"

# All dev-db/postgresql ebuilds from 10.0 on are well supported. Earlier
# ebuilds may present some quality of life issues.
PDEPEND="
	!<dev-db/postgresql-9.6.2-r1:9.6
	!<dev-db/postgresql-9.5.6-r1:9.5
	!<dev-db/postgresql-9.4.11-r1:9.4
	!<dev-db/postgresql-9.3.16-r1:9.3
	!<dev-db/postgresql-9.2.20-r1
"

src_install() {
	insinto /usr/share/eselect/modules
	doins postgresql.eselect

	dosym eselect /usr/bin/postgresql-config
}

pkg_postinst() {
	postgresql-config update
}
