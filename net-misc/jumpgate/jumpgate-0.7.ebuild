# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/jumpgate/jumpgate-0.7.ebuild,v 1.11 2012/12/08 22:08:25 ulm Exp $

EAPI=4

inherit autotools eutils toolchain-funcs

DESCRIPTION="An advanced TCP connection forwarder"
HOMEPAGE="http://jumpgate.sourceforge.net/"
SRC_URI="http://jumpgate.sourceforge.net/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

src_prepare() {
	if [ "$(gcc-major-version)" == "4" ] ; then
		sed -i -e '/^AC_CHECK_TYPE/d' configure.in || die
		eautoreconf
	fi
}

src_install() {
	emake install install_prefix="${D}"
	dodoc README ChangeLog
}
