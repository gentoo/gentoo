# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
