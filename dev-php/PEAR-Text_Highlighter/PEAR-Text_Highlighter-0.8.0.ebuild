# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="A package for syntax highlighting"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# There is a documented dependency on XML_Parser, but that's only needed
# for development -- if you want to *generate* the PHP class files. The
# ones in the release are already pre-generated. The dependency on the
# XML_Serializer, on the other hand, is not documented but is requird
# by the XML output renderer.
RDEPEND=">=dev-php/PEAR-PEAR-1.10.1
	dev-php/PEAR-XML_Serializer"
