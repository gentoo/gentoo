# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${P/PEAR-/}"

DESCRIPTION="Handle and modify HTTP headers and status codes in PHP"
HOMEPAGE="http://pear.php.net/package/HTTP_Header"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-lang/php:*
	dev-php/PEAR-HTTP"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r HTTP
}
