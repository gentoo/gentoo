# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="PEAR:Net_LDAP2 successor, provides functionality for accessing LDAP"
HOMEPAGE="https://gitlab.com/roundcube/net_ldap3"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ~ppc64 ~sparc x86"

DEPEND=""
RDEPEND="dev-lang/php:*[ldap]"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/php"
	doins -r lib/*
}
