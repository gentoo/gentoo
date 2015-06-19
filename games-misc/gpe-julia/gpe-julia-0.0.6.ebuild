# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/gpe-julia/gpe-julia-0.0.6.ebuild,v 1.3 2015/02/06 05:33:40 tupone Exp $
EAPI=5
GPE_TARBALL_SUFFIX="gz"
GPE_MIRROR="http://gpe.linuxtogo.org/download/source"
inherit eutils gpe

DESCRIPTION="A Julia/Mandelbrot set generator for GPE"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	gpe-base/libgpewidget"
DEPEND="${DEPEND}
	${RDEPEND}"

src_unpack() {
	gpe_src_unpack "$@"
}

src_prepare() {
	sed -i -e s@'#include <gpe/render.h>'@@ "${S}"/main.c \
		|| die "main.c sed failed"

	# miknix: nls is incomplete
	sed -i -e 's;include $(BUILD)/Makefile.translation;;' Makefile \
		|| die "Makefile sed failed"

	# miknix: This packages doesn't currrently support autotools
	mv -f gpe-julia.desktop.in gpe-julia.desktop
	sed -i -e 's/^_//' gpe-julia.desktop \
		|| die ".desktop sed failed"
	epatch "${FILESDIR}"/${P}-underlink.patch
}
