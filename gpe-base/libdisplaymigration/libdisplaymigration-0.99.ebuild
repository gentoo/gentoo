# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/libdisplaymigration/libdisplaymigration-0.99.ebuild,v 1.4 2014/03/01 22:34:56 mgorny Exp $

EAPI="2"

inherit gpe

DESCRIPTION="Gtk+ display migration library"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="${IUSE}"
GPE_DOCS=""

RDEPEND="${RDEPEND}
	x11-libs/gtk+:2
	>=dev-libs/libgcrypt-1.2.1:0"

DEPEND="${DEPEND}
	${RDEPEND}"

src_prepare() {
	gpe_src_prepare

	# Let the PM handle strip
	sed -i -e s/'install -s'/'install'/ Makefile || die
	# Fix for passing multilib checks
	sed -i -e 's@$(PREFIX)/lib@$(PREFIX)/'"$(get_libdir)@g" Makefile \
		|| die "Cannot sed Makefile"
}

src_install() {
	gpe_src_install "$@"
	make DESTDIR="${D}" PREFIX=/usr install-devel
}
