# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Base class for other HTML classes"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc64 ~s390 sparc x86"
IUSE=""

src_install() {
	insinto /usr/share/php/HTML
	doins Common.php
	php-pear-r2_install_packagexml
}
