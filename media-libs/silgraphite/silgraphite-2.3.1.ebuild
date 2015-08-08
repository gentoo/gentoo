# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Rendering engine for complex non-Roman writing systems"
HOMEPAGE="http://graphite.sil.org/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="|| ( CPL-0.5 LGPL-2.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="pango static-libs truetype xft"

RDEPEND="
	pango? ( x11-libs/pango media-libs/fontconfig )
	truetype? ( media-libs/freetype:2 )
	xft? ( x11-libs/libXft )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-aligned_access.patch"

	# Drop DEPRECATED flags, bug #385533
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		wrappers/pangographite/Makefile.am wrappers/pangographite/Makefile.in \
		wrappers/pangographite/graphite/Makefile.am || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with xft) \
		$(use_with truetype freetype) \
		$(use_with pango pangographite)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
