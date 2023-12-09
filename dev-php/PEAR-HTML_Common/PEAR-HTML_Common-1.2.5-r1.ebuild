# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Base class for other HTML classes"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~s390 sparc x86"
IUSE=""

src_install() {
	insinto /usr/share/php/HTML
	doins Common.php
	php-pear-r2_install_packagexml
}
