# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Perform multiple HTTP requests and process their results"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-HTTP_Request-1.2"

PATCHES=( "${FILESDIR}/modern-php.patch" )

src_install() {
	insinto /usr/share/php/HTTP
	doins -r Client.php Client
	php-pear-r2_install_packagexml
	einstalldocs
}
