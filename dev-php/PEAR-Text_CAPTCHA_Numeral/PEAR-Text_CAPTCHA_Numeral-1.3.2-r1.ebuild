# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Generates mathematical operations and answers to prove user is human"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="test"
DEPEND="test? ( dev-php/PEAR-PEAR )"

HTML_DOCS=( examples/liveNumeral.php examples/numeral1.php )

src_test() {
	peardev run-tests tests || die
}
