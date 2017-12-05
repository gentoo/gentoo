# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

KEYWORDS="amd64 x86"

DESCRIPTION="OS independet wrapper class for executing traceroute calls"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	local DOCS=( docs/README docs/TODO )
	local HTML_DOCS=( docs/examples/example1.php )
	insinto /usr/share/php/Net
	doins Traceroute.php
	php-pear-r2_install_packagexml
	einstalldocs
}
