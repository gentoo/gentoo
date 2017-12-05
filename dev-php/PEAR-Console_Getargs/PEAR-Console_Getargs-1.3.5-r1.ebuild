# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit php-pear-r2

DESCRIPTION="A command-line arguments parser"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

src_prepare() {
	eapply "${FILESDIR}/new-reference-fix.patch"
	eapply_user
}
