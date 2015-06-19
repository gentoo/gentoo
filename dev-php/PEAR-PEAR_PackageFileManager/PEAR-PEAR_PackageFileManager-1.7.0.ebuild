# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PEAR_PackageFileManager/PEAR-PEAR_PackageFileManager-1.7.0.ebuild,v 1.4 2015/04/15 01:31:39 grknight Exp $

EAPI=4

inherit php-pear-r1

DESCRIPTION="Takes an existing package.xml file and updates it with a new filelist and changelog"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

DEPEND=">=dev-php/pear-1.8.1"
RDEPEND="dev-lang/php[xml,simplexml]
	!minimal? ( >=dev-php/PEAR-PHP_CompatInfo-1.4.0 )"
