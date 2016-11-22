# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN#PEAR-}"
DESCRIPTION="Provides a class to decode mime messages (split from PEAR-Mail_Mime)"
HOMEPAGE="http://pear.php.net/package/Mail_mimeDecode"
SRC_URI="http://pear.php.net/get/${MY_PN}-${PV}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/php:* >=dev-php/pear-1.8.1 >=dev-php/PEAR-Mail_Mime-1.5.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /usr/share/php
	doins -r Mail
}

pkg_postinst() {
	peardev install -nrO --force "${WORKDIR}/package.xml" 2> /dev/null
}

pkg_postrm() {
	peardev uninstall -nrO --force pear.php.net/${MY_PN}
}
