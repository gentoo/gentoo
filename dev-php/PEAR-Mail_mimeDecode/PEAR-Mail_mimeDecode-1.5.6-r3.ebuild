# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="Provides a class to decode mime messages (split from PEAR-Mail_Mime)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-php/PEAR-Mail_Mime-1.5.2"
DEPEND="test? ( ${RDEPEND} dev-php/PEAR-PEAR )"

PATCHES=(
	"${FILESDIR}/PEAR-Mail_mimeDecode-1.5.6-r3-php8_compat.patch"
)

src_test() {
	pear run-tests tests || die
}
