# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2 edos2unix

DESCRIPTION="Class that provides multiple interfaces for sending emails"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-php/PEAR-Net_SMTP-1.4.1"
BDEPEND="test? ( ${RDEPEND} dev-php/PEAR-PEAR )"

src_prepare() {
	# test files are DOS line-endings and default patch strips without this line
	patch -p1 --binary < "${FILESDIR}/PEAR-Mail-1.5.0-fix-tests.patch"
	default
}

src_test() {
	peardev run-tests tests || die
}
