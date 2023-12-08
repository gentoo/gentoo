# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="BBCode parser for Text_Wiki"

LICENSE="LGPL-2.1 PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""
RDEPEND=">=dev-php/PEAR-Text_Wiki-1.0.3"

DOCS=(	doc/BBCodeParser_V2.ini
	doc/BBCodeParser.php
	doc/README_BBCodeParser
	doc/parser.php
	doc/BBtest.txt )
