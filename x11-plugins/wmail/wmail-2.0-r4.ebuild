# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Window Maker dock application showing incoming mail"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/70"
SRC_URI="http://www.minet.uni-jena.de/~topical/sveng/wmail/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/libdockapp-0.7:="

DEPEND="${RDEPEND}
	>=sys-apps/sed-4.1.4-r1"

src_prepare() {
	epatch "${FILESDIR}"/${P}.support-libdockapp-0.5.0.patch

	# make from parsing in maildir format faster, thanks
	# to Stanislav Kuchar
	epatch "${FILESDIR}"/${P}.maildir-parse-from.patch

	# fix LDFLAGS ordering, see bug #248620
	sed -i 's/$(LIBS) -o $@ $^/-o $@ $^ $(LIBS)/' "${S}/src/Makefile.in"

	# Honour Gentoo LDFLAGS, see bug #337407
	sed -i 's/-o $@ $^ $(LIBS)/$(LDFLAGS) -o $@ $^ $(LIBS)/' "${S}/src/Makefile.in"
	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_configure() {
	econf --enable-delt-xpms
}

src_install() {
	dobin src/wmail
	dodoc README wmailrc-sample
}
