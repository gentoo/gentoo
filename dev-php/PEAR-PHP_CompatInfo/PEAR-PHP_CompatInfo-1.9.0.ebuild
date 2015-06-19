# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PHP_CompatInfo/PEAR-PHP_CompatInfo-1.9.0.ebuild,v 1.2 2014/08/10 20:54:33 slyfox Exp $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Find out the minimum version and the extensions required for a piece of code to run"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="dev-lang/php[tokenizer]
	!minimal? ( >=dev-php/PEAR-Console_Table-1.0.5
		    >=dev-php/PEAR-Console_Getargs-1.3.3
		    >=dev-php/PEAR-XML_Util-1.1.4
		    >=dev-php/phpunit-3.2.0 )"
