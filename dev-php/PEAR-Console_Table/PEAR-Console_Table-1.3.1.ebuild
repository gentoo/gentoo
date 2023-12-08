# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

DESCRIPTION="Class that makes it easy to build console style tables"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
BDEPEND="test? ( dev-php/pear )"

src_install() {
	insinto /usr/share/php/Console
	doins Table.php
	php-pear-r2_install_packagexml
}

src_test() {
	pear run-tests tests || die "Tests failed"
}
