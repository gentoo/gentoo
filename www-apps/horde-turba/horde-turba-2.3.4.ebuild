# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-turba/horde-turba-2.3.4.ebuild,v 1.8 2012/09/09 17:07:25 armin76 Exp $

HORDE_PHP_FEATURES="-o mysql mysqli odbc postgres ldap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Turba is the Horde address book / contact management program"

KEYWORDS="amd64 hppa ppc x86"
IUSE="ldap"

DEPEND=""
RDEPEND=">=www-apps/horde-3
	ldap? ( dev-php/PEAR-Net_LDAP )"

src_unpack() {
	horde_src_unpack

	# Remove vcf specs as they don't install and are not useful to the end user
	rm -r docs/vcf || die 'removing docs failed'
}
