# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-openid/php-openid-2.2.3_pre20140423.ebuild,v 1.2 2015/04/18 13:01:30 swegener Exp $

EAPI=5
MY_PV="fff9217fb1acda132702730b66b10981ea9d4cac"
MY_P="${PN}-${MY_PV}"

PHP_LIB_NAME="Auth"
DESCRIPTION="PHP OpenID implementation"
HOMEPAGE="https://github.com/openid/php-openid"
SRC_URI="https://github.com/openid/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="|| ( dev-lang/php[gmp] dev-lang/php[bcmath] )
	dev-lang/php[curl,xml,ssl]
	net-misc/curl[ssl]"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto "/usr/share/php/${PN}"
	cd "${S}/Auth" && doins -r .

	use examples && dodoc -r ../examples
}

pkg_postinst() {
	elog "This ebuild can optionally make use of:"
	elog "    dev-php/PEAR-DB"
}
