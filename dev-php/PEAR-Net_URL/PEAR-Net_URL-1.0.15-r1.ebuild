# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Easy parsing of URLs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

src_install() {
	local HTML_DOCS=( docs/example.php )
	insinto /usr/share/php/Net
	doins URL.php
	php-pear-r2_install_packagexml
	einstalldocs
}
