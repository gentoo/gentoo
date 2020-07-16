# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

DESCRIPTION="Creating, validating, processing HTML forms methods (PHP5 optimize)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

DEPEND=">=dev-lang/php-5.2.0:*"
RDEPEND="${DEPEND}
	>=dev-php/PEAR-HTML_Common2-2.1.0"

src_install() {
	HTML_DOCS=( data/quickform.css data/js )
	use examples && HTML_DOCS+=( docs/examples )
	php-pear-r2_src_install
}
