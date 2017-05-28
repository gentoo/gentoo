# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_DOMAIN="pear.phpdoc.org"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"

inherit php-pear-r2

DESCRIPTION="Automatic documenting of php api directly from the source"
SRC_URI="http://${PHP_PEAR_URI}/get/${PEAR_P}.tgz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

# block old version that provides the same binary
DEPEND="!dev-php/PEAR-PhpDocumentor"
RDEPEND="media-gfx/graphviz
	dev-lang/php:*[iconv,intl,xmlreader,xslt]"

src_prepare() {
	sed -i	-e "s~@php_dir@~${EPREFIX}/usr/share/php~" \
		"${S}/bin/phpdoc" || die
	eapply_user
}

src_install() {
	exeinto /usr/bin
	doexe bin/phpdoc
	insinto /usr/share/php/${PN}
	doins -r vendor src/* phpdoc.dist.xml bin/phpdoc.php
	insinto /usr/share/php/data/${PN}
	doins -r ansible data features box.json composer.json composer.lock phpmd.xml.dist wercker.yml
	# install manual, tutorial, reference material
	use doc && dodoc -r docs/*
	php-pear-r2_install_packagexml
	einstalldocs
}
