# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/YAML/YAML-1.0.6-r1.ebuild,v 1.4 2015/04/29 09:05:55 ago Exp $

EAPI=5

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.symfony-project.com"
PHP_PEAR_PN="YAML"

inherit php-pear-lib-r1

DESCRIPTION="The Symfony YAML Component"
HOMEPAGE="http://pear.symfony-project.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""
