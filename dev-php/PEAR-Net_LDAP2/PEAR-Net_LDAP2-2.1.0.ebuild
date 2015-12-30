# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit php-pear-r1

KEYWORDS="alpha amd64 hppa ppc ~ppc64 sparc x86"

DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[ldap]"
