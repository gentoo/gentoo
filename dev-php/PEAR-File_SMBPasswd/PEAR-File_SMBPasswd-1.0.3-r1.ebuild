# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit php-pear-r2

DESCRIPTION="Class for managing SAMBA style password files"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND=">=dev-lang/php-5.3:*
	>=dev-php/PEAR-Crypt_CHAP-1.0.0"

src_install() {
	insinto /usr/share/php/File
	doins SMBPasswd.php
	php-pear-r2_install_packagexml
	einstalldocs
}
