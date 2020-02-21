# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="PEAR MDB combines the PEAR DB and Metabase php database abstraction layers"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND="dev-php/PEAR-XML_Parser"
HTML_DOCS=( doc/xml_schema.xsl doc/skeleton.php doc/xml_schema_documentation.html doc/tutorial.html doc/datatypes.html doc/Modules_Manager_skeleton.php )
