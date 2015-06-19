# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_LDAP2/PEAR-Net_LDAP2-2.0.12.ebuild,v 1.7 2012/03/18 19:17:46 armin76 Exp $

EAPI="4"

inherit php-pear-r1

KEYWORDS="alpha amd64 hppa ppc sparc x86"

DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[ldap]"
