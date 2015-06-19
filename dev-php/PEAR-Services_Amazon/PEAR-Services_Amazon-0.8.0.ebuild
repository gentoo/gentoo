# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Services_Amazon/PEAR-Services_Amazon-0.8.0.ebuild,v 1.3 2015/01/06 21:37:06 grknight Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides access to Amazon's retail and associate web services"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"
RDEPEND=">=dev-php/PEAR-HTTP_Request-1.2.4-r1
	>=dev-php/PEAR-XML_Serializer-0.17.0
	!minimal? ( dev-php/PEAR-Cache )"
