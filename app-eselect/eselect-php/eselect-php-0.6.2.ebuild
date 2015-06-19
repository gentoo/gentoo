# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-php/eselect-php-0.6.2.ebuild,v 1.2 2015/04/22 12:33:15 pinkbyte Exp $

EAPI=3

DESCRIPTION="PHP eselect module"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://olemarkus.org/~olemarkus/gentoo/eselect-php-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=app-admin/eselect-1.2.4
		!app-admin/php-toolkit"
RDEPEND="${DEPEND}"

src_install() {
	mv eselect-php-${PV} php.eselect
	insinto /usr/share/eselect/modules/
	doins php.eselect
}
