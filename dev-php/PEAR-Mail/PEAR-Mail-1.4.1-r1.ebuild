# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Class that provides multiple interfaces for sending emails"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-php/PEAR-Net_SMTP-1.4.1"
DEPEND="test? ( ${RDEPEND} dev-php/PEAR-PEAR )"

src_test() {
	peardev run-tests tests || die
}
