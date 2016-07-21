# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit php-pear-r1

DESCRIPTION="Adds indentation and linebreaks, replace entities, formats comments and makes XML easier to read"
LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND="dev-php/PEAR-XML_Util
	dev-php/PEAR-XML_Parser"
