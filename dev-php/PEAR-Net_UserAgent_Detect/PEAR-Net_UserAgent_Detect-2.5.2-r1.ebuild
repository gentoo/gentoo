# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Determines Web browser, version, and platform from an HTTP user agent string"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc64 sparc x86"
IUSE=""

src_install() {
	local HTML_DOCS=( tests/example.php )
	insinto /usr/share/php/Net/UserAgent
	doins -r Detect Detect.php
	php-pear-r2_install_packagexml
	einstalldocs
}
