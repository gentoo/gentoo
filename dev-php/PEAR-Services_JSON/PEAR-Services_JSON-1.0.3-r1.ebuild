# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

IUSE=""
DESCRIPTION="PHP implementaion of json_encode/decode"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
PATCHES=( "${FILESDIR}/JSON-1.0.3-upstream-typo.patch" "${FILESDIR}/JSON-1.0.3-constructor.patch" )

src_install() {
	php-pear-r2_src_install
	insinto /usr/share/php/Services
	doins JSON.php
}
