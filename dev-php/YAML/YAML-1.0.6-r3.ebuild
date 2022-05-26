# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_DOMAIN="pear.symfony-project.com"
PHP_PEAR_PKG_NAME="YAML"

inherit php-pear-r2

DESCRIPTION="The Symfony YAML Component"
HOMEPAGE="http://pear.symfony-project.com/"
SRC_URI="http://pear.symfony-project.com/get/${PEAR_P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE=""

src_install() {
	insinto /usr/share/php/SymfonyComponents/YAML
	doins lib/*
	php-pear-r2_install_packagexml
	einstalldocs
}
