# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
