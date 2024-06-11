# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="Class that makes it easy to build console style tables"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
BDEPEND="test? ( dev-php/pear )"

PATCHES=( "${FILESDIR}/fromArray-is-static.patch" )

src_install() {
	insinto /usr/share/php/Console
	doins Table.php
	php-pear-r2_install_packagexml
}

src_test() {
	pear run-tests tests || die "Tests failed"
}
