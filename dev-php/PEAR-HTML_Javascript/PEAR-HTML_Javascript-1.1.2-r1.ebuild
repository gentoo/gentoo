# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

IUSE=""
DESCRIPTION="Provides an interface for creating simple JS scripts within PHP"
LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

src_install() {
	insinto /usr/share/php/HTML
	doins -r Javascript Javascript.php
	php-pear-r2_install_packagexml
	einstalldocs
}
