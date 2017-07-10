# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides multiple methods for configuration manipulation"
LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="xml"
RDEPEND="xml? ( dev-php/PEAR-XML_Parser dev-php/PEAR-XML_Util )"
