# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit php-pear-r1

DESCRIPTION="Class for multilingual applications management"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="minimal xml"

RDEPEND="dev-lang/php[nls]
	!minimal? ( dev-php/PEAR-Cache_Lite
			dev-php/PEAR-DB
			dev-php/PEAR-DB_DataObject
			dev-php/PEAR-MDB
			dev-php/PEAR-MDB2
			dev-php/PEAR-File_Gettext
			>=dev-php/PEAR-I18Nv2-0.9.1 )
	xml? ( >=dev-php/PEAR-XML_Serializer-0.13.0 )"
