# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Various methods to check files to update an existing package.xml file"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-PEAR-1.10.1
	>=dev-php/PEAR-XML_Serializer-0.19.0
	>=dev-lang/php-5.3:*[xml,simplexml]"
