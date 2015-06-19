# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/svrcore/svrcore-4.0.4.ebuild,v 1.3 2012/07/11 18:15:41 lxnay Exp $

EAPI=2

inherit multilib autotools eutils

DESCRIPTION="Mozilla LDAP C SDK"
HOMEPAGE="http://wiki.mozilla.org/LDAP_C_SDK"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/directory/svrcore/releases/"${PV}"/src/"${P}".tar.bz2"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-libs/nss-3.11
	>=dev-libs/nspr-4.6"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-gentoo.patch
	eautoreconf
}

src_configure() {
	econf  --with-pic || die "cannot configure"
}

src_install () {
	einstall  || die "emake failed"

	# cope with libraries being in /usr/lib/svrcore
	echo "LDPATH=/usr/$(get_libdir)/svrcore" > 08svrcore
	dodir /etc/env.d
	doenvd 08svrcore

	dodoc ChangeLog INSTALL NEWS TODO README AUTHORS
}
