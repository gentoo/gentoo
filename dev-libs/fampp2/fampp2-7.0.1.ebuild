# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/fampp2/fampp2-7.0.1.ebuild,v 1.2 2013/02/05 09:30:01 dev-zero Exp $

EAPI="5"

inherit eutils

DESCRIPTION="C++ wrapper for fam"
HOMEPAGE="https://sourceforge.net/projects/fampp/"
SRC_URI="mirror://sourceforge/fampp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples stlport"

RDEPEND="virtual/fam
	stlport? ( dev-libs/STLport )
	>=dev-libs/ferrisloki-2.0.3[stlport?]
	dev-libs/libsigc++:2
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -ri \
		-e '/^C(XX)?FLAGS/s:-O0 -g::' \
		-e '/^LDFLAGS/s:-Wl,-O1 -Wl,--hash-style=both::' \
		configure || die "sed failed"
}

src_configure() {
	# glib and gtk+ are only required for some examples
	econf \
		--disable-glibtest \
		--disable-gtktest \
		--with-stlport=/usr/include/stlport \
		$(use_enable stlport)

	if ! use examples ; then
		sed -i -e '/^SUBDIRS/ s/examples//' Makefile.in || die "sed failed"
	fi
}

src_install() {
	default
	prune_libtool_files
}
