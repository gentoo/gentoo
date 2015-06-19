# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Config/PEAR-Config-1.10.12-r1.ebuild,v 1.1 2014/11/06 15:07:27 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides methods for configuration manipulation. Your configuration's swiss-army knife"
LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="xml"
RDEPEND="xml? ( dev-php/PEAR-XML_Parser dev-php/PEAR-XML_Util )"
