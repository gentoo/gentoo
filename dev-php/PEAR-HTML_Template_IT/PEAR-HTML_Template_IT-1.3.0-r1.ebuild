# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Integrated Templates"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="examples test"
DEPEND="test? ( dev-php/phpunit ${RDEPEND} )"

src_prepare() {
	eapply "${FILESDIR}/preg-callback.patch" \
		"${FILESDIR}/constructor.patch"
	eapply_user
}

src_install() {
	use examples && HTML_DOCS=(
		examples/sample_it.php
		examples/sample_itx_addblockfile.php
		examples/templates/
	)
	php-pear-r2_src_install
}

src_test() {
	phpunit tests/AllTests.php || die
}
