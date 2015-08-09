# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Collect system informations for the hardware4linux.info site"
HOMEPAGE="http://hardware4linux.info/"
SRC_URI="http://hardware4linux.info/res/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}
	>=sys-apps/dmidecode-2.8
	>=sys-apps/pciutils-2.2.0"

src_prepare() {
	# fix syntax error
	sed -e 's:perl -p -i -e "s@/var/lib/hwreport@$(vardir)@" -e "s@/usr/sbin@$(bindir)@" $(DESTDIR)$(crondir)/$(PKG):perl -p -i -e "s@/var/lib/hwreport@$(vardir)@;" -e "s@/usr/sbin@$(bindir)@" $(DESTDIR)$(crondir)/$(PKG):' -i "${S}"/Makefile
	# respect LDFLAGS
	sed -e 's:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' -i Makefile
}

pkg_postinst() {
	elog "You can now generate your reports and post them on ${HOMEPAGE}"
}
