# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Package for generating Excel spreadsheets"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
RDEPEND=">=dev-lang/php-5.4:*[iconv]
	>=dev-php/PEAR-OLE-0.5-r1"
IUSE=""
