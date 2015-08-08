# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="The MAD audio player"
HOMEPAGE="http://www.underbit.com/products/mad/"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="alsa debug nls"

RDEPEND=">=media-libs/libid3tag-0.15.1b
	>=media-libs/libmad-0.15.1b
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

DOCS="CHANGES CREDITS README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-macos.patch
	eautoreconf #need new libtool for interix
	epunt_cxx #74499
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable debug debugging) \
		$(use_with alsa) \
		--without-esd
}
