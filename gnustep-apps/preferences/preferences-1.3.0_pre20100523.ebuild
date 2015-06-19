# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/preferences/preferences-1.3.0_pre20100523.ebuild,v 1.5 2014/08/10 21:19:56 slyfox Exp $

EAPI=3
inherit gnustep-2

S=${WORKDIR}/${PN/p/P}

DESCRIPTION="Preferences is the GNUstep program with which you define your own personal user experience"
HOMEPAGE="http://www.nongnu.org/backbone/apps.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

DEPEND="gnustep-libs/prefsmodule"
RDEPEND=""

src_prepare() {
	sed -i -e 's#include $(TOP_SRCDIR)/Backbone.make##' GNUmakefile \
		Modules/*/GNUmakefile || die "backbone sed failed"
}
