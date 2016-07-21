# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Utility to select the default PostgreSQL slot"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~titanofold/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"

src_install() {
	keepdir /etc/eselect/postgresql

	insinto /usr/share/eselect/modules
	doins postgresql.eselect

	dosym /usr/bin/eselect /usr/bin/postgresql-config
}

pkg_postinst() {
	postgresql-config update
}
