# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnustep-2

DESCRIPTION="GNUstep LDAP library for open ldap C libraries"
HOMEPAGE="http://www.gnustep.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-nds/openldap"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e "s|#include <GNUstepBase/GSCategories.h>||" \
		GSLDAPCom.h || die "GSCategories.h sed failed"
}
