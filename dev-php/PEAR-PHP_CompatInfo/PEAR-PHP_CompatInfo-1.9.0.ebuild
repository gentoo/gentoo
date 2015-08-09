# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
