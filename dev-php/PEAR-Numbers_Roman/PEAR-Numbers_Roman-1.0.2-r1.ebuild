# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides methods for converting to and from Roman Numerals"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
HTML_DOCS=( docs/examples/example.php )

src_install() {
	insinto /usr/share/php/Numbers
	doins Roman.php
	php-pear-r2_install_packagexml
	einstalldocs
}
