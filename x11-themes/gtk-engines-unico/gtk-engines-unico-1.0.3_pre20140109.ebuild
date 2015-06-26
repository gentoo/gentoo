# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-unico/gtk-engines-unico-1.0.3_pre20140109.ebuild,v 1.3 2015/06/26 09:24:34 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules

inherit autotools-multilib eutils

MY_PN=${PN/gtk-engines-}
MY_PV=${PV/_pre/+14.04.}
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="The Unico GTK+ 3.x theming engine"
HOMEPAGE="https://launchpad.net/unico"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MY_P}.orig.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.10[glib,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.5.2:3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_configure() {
	# $(use_enable debug) controls CPPFLAGS -D_DEBUG and -DNDEBUG but they are currently
	# unused in the code itself.
	autotools-multilib_src_configure \
		--disable-static \
		--disable-debug \
		--disable-maintainer-flags
}
