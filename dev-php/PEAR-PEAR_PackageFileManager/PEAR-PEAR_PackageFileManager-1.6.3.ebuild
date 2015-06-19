# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PEAR_PackageFileManager/PEAR-PEAR_PackageFileManager-1.6.3.ebuild,v 1.5 2014/08/10 20:54:12 slyfox Exp $

EAPI=4

inherit php-pear-r1

DESCRIPTION="Takes an existing package.xml file and updates it with a new filelist and changelog"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="dev-lang/php[xml,simplexml]
	!minimal? ( >=dev-php/PEAR-PHP_CompatInfo-1.4.0 )"
