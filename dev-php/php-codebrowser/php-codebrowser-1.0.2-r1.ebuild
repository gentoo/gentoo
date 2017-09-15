# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_DOMAIN="pear.phpunit.de"
PHP_PEAR_PKG_NAME="PHP_CodeBrowser"
inherit php-pear-r2

DESCRIPTION="Creates highlighted code by reading xml reports from codesniffer or phpunit"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://pear.phpunit.de"
SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_P}.tgz"

RDEPEND="${RDEPEND}
	>=dev-php/PEAR-Console_CommandLine-1.1.3
	>=dev-php/File_Iterator-1.3.0
	>=dev-php/PEAR-Log-1.12.1"

src_prepare() {
	sed -i	-e "s~@php_dir@~${EPREFIX}/usr/share/php~" \
		-e "s~@data_dir@~${EPREFIX}/usr/share/php/data~" \
		-e "s~@package_version@~${PV}~" \
		"${S}/src/CLIController.php" || die
	sed -i	-e "s~@php_dir@~${EPREFIX}/usr/share/php~" \
		"${S}/bin/phpcb.php" || die
	eapply_user
}

src_install() {
	local DOCS=( CHANGELOG.markdown README.markdown )
	insinto /usr/share/php/data/${PHP_PEAR_PKG_NAME}
	doins -r templates
	insinto /usr/share/php/${PHP_PEAR_PKG_NAME}
	doins -r src/*
	exeinto /usr/bin
	newexe bin/phpcb.php phpcb
	php-pear-r2_install_packagexml
	einstalldocs
}
