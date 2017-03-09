# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.symfony-project.com"
PHP_PEAR_PN="YAML"

inherit php-pear-r2

DESCRIPTION="The Symfony YAML Component"
HOMEPAGE="http://pear.symfony-project.com/"
SRC_URI="http://pear.symfony-project.com/get/${PEAR_P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""
