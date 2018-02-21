# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Generating CHAP packets"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"
RDEPEND="dev-lang/php:*[crypt,hash]"
DEPEND="test? ( ${RDEPEND} dev-php/PEAR-PEAR )"
PATCHES=( "${FILESDIR}/CHAP-1.5.0-constructor.patch" )

src_install() {
	php-pear-r2_src_install
	insinto /usr/share/php/Crypt
	doins CHAP.php
}

src_test() {
	pear run-tests tests/Crypt_CHAP.phpt || die
}
