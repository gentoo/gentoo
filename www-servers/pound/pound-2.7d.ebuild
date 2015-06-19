# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/pound/pound-2.7d.ebuild,v 1.1 2014/10/25 03:42:11 patrick Exp $

EAPI=5
inherit eutils

MY_P=${P/p/P}
DESCRIPTION="A http/https reverse-proxy and load-balancer"
HOMEPAGE="http://www.apsis.ch/pound/"
SRC_URI="http://www.apsis.ch/pound/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/libpcre
	dev-libs/openssl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	dodir /usr/sbin
	cp "${S}"/pound "${D}"/usr/sbin/
	cp "${S}"/poundctl "${D}"/usr/sbin/

	doman pound.8
	doman poundctl.8
	dodoc README FAQ

	dodir /etc/init.d
	newinitd "${FILESDIR}"/pound.init-1.9 pound

	insinto /etc
	newins "${FILESDIR}"/pound-2.2.cfg pound.cfg
}

pkg_postinst() {
	elog "No demo-/sample-configfile is included in the distribution -"
	elog "read the man-page for more info."
	elog "A sample (localhost:8888 -> localhost:80) for gentoo is given in \"/etc/pound.cfg\"."
	echo
	ewarn "You will have to upgrade you configuration file, if you are"
	ewarn "upgrading from a version <= 2.0."
	echo
	ewarn "The 'WebDAV' config statement is no longer supported!"
	ewarn "Please adjust your configuration, if necessary."
	echo
}
