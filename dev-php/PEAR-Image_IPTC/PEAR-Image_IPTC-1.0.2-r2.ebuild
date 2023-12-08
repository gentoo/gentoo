# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="This package provides a mechanism for modifying IPTC header information"
LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

src_install() {
	insinto /usr/share/php/Image
	doins IPTC.php
	php-pear-r2_install_packagexml
}
