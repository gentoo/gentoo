# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Interface for reading from and writing to fortune files"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=">=dev-lang/php-5.1.4:*"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

src_test(){
	phpunit tests || die
}
