# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTTP_Request2/PEAR-HTTP_Request2-2.1.1.ebuild,v 1.1 2013/03/25 19:57:18 mabi Exp $

EAPI=4

inherit php-pear-r1

DESCRIPTION="Provides an easy way to perform HTTP requests"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+curl +fileinfo +ssl +zlib"

RDEPEND="dev-lang/php[curl?,fileinfo?,ssl?,zlib?]
>=dev-php/PEAR-Net_URL2-0.3.0"
