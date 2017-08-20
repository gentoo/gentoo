# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides a class to decode mime messages (split from PEAR-Mail_Mime)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-Mail_Mime-1.5.2"

#src_install() {
#	insinto /usr/share/php
#	doins -r Mail
#}
