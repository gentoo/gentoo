# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pure-PHP arbitrary precision integer arithmetic library"
HOMEPAGE="http://pear.php.net/package/${MY_PN}
	http://phpseclib.sourceforge.net/documentation/math.html"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/php:*"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r Math

	dodoc demo/{benchmark,demo}.php
}
