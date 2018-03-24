# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
DESCRIPTION="Fast and safe little cache system"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=">=dev-php/pear-1.10.1"
RDEPEND="${DEPEND}"

src_test() {
	peardev run-tests -r || die
}

src_install() {
	local DOCS=( README.md TODO docs/technical docs/examples )
	php-pear-r2_src_install
}
