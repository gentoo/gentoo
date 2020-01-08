# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Framework for caching of arbitrary data"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

src_install() {
	insinto /usr/share/php
	doins Cache.php
	# HTTP_Request is deprecated and superceeded upstream, bypassing
	insinto /usr/share/php/Cache
	doins -r Application.php Container Container.php Error.php Function.php Graphics.php OutputCompression.php Output.php
	php-pear-r2_install_packagexml
	einstalldocs
}
