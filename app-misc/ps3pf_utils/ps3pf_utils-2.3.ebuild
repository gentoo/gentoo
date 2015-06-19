# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ps3pf_utils/ps3pf_utils-2.3.ebuild,v 1.3 2012/02/20 01:25:26 floppym Exp $

inherit flag-o-matic

DESCRIPTION="Utilities to set the ps3 specific features"
HOMEPAGE="http://www.playstation.com/ps3-openplatform/index.html"
SRC_URI="mirror://kernel/linux/kernel/people/geoff/cell/ps3-utils/ps3-utils-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE=""

# fixme: depend on a version of sys-kernel/linux-headers that supports ps3

S=${WORKDIR}/ps3-utils-${PV}

src_install() {
	emake DESTDIR="${D}" install || die
}
