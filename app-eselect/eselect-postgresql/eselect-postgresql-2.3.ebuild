# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility to select the default PostgreSQL slot"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~titanofold/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos ~x86-solaris"

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
