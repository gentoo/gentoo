# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="Powerful MUD client with a built-in PERL interpreter"
HOMEPAGE="http://kildclient.sourceforge.net"
SRC_URI="mirror://sourceforge/kildclient/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnutls spell"

RDEPEND="
	dev-lang/perl
	dev-perl/Locale-gettext
	dev-perl/JSON
	sys-libs/zlib
	x11-libs/gtk+:3
	virtual/libintl
	spell? ( app-text/gtkspell:3 )
	gnutls? ( net-libs/gnutls )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--localedir=/usr/share/locale \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use_with spell gtkspell) \
		$(use_with gnutls libgnutls) \
		$(use_with doc docs)
}
