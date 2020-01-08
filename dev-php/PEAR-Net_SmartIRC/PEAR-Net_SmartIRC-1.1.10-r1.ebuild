# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

HOMEPAGE="https://pear.php.net/package/${MY_PN}"
# The PEAR tarball is missing some docs as of v1.10.0.
SRC_URI="https://github.com/pear/${MY_PN}/archive/v${PV}.tar.gz
	-> ${MY_P}.tar.gz"
DESCRIPTION="PHP class to communicate with IRC networks"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc examples"

RDEPEND="dev-lang/php:*"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc CREDITS FEATURES docs/HOWTO README.md TODO
	use examples && dodoc -r docs/examples

	if use doc; then
		dodoc docs/DOCUMENTATION
		dodoc -r docs/HTML
	fi

	insinto /usr/share/php
	doins -r Net
}
