# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

KEYWORDS="~alpha amd64 ~arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"

DESCRIPTION="Validation class"
LICENSE="BSD"
SLOT="0"
IUSE="minimal test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-php/PEAR-PEAR dev-php/PEAR-Date )"
RDEPEND="!minimal? ( dev-php/PEAR-Date )"
PATCHES=( "${FILESDIR}/0.8.5-fix-test-php7.patch" )
HTML_DOCS=( docs/Example_Locale.php docs/sample_multiple.php )

src_test() {
	peardev run-tests tests || die
}
