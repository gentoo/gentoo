# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

DESCRIPTION="Generating CHAP packets"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
# Crypt_CHAP_MSv1 needs mcrypt which is gone in 7.2+
RDEPEND="|| (  ( dev-php/pecl-mcrypt >=dev-lang/php-7.2:*[hash(+)] )
		<dev-lang/php-7.2:*[crypt,hash]
)"
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
