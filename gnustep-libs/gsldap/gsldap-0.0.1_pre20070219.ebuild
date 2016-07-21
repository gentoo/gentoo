# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit gnustep-2

DESCRIPTION="GNUstep LDAP library for open ldap C libraries"
HOMEPAGE="http://www.gnustep.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="net-nds/openldap"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s|#include <GNUstepBase/GSCategories.h>||" \
		GSLDAPCom.h || die "GSCategories.h sed failed"
}
