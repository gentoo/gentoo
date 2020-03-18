# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils ltprune

MY_PN=${PN/gtk-engines-}
MY_P=${MY_PN}-${PV}

DESCRIPTION="The Unico GTK+ 3.x theming engine"
HOMEPAGE="https://launchpad.net/unico"
#SRC_URI="https://launchpad.net/${MY_PN}/${PV%.*}/${PV}/+download/${MY_P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~tetromino/distfiles/${PN}/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/cairo-1.10[glib]
	>=x11-libs/gtk+-3.5.2:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-1.0.2

src_configure() {
	# $(use_enable debug) controls CPPFLAGS -D_DEBUG and -DNDEBUG but they are currently
	# unused in the code itself.
	econf \
		--disable-static \
		--disable-debug \
		--disable-maintainer-flags
}

src_install() {
	default
	prune_libtool_files --modules
}
