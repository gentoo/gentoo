# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command-line option parser"
HOMEPAGE="https://pear.php.net/package/Console_Getopt"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="dev-lang/php:*"
PDEPEND="dev-php/PEAR-PEAR"

src_install() {
	insinto /usr/share/php
	doins -r Console
}
