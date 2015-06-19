# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Text_Highlighter/PEAR-Text_Highlighter-0.7.3.ebuild,v 1.1 2014/11/07 14:15:03 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="A package for syntax highlighting"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-php/PEAR-XML_Parser
	dev-php/PEAR-Console_Getopt"
