# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2 eutils

DESCRIPTION="Miscellaneous HTTP utilities"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
DEPEND="test? ( dev-php/PEAR-PEAR )"

src_prepare() {
	# fix nasty DOS linebreaks
	edos2unix HTTP.php
	default
}

src_test() {
	pear run-tests tests || die "Tests failed"
}
