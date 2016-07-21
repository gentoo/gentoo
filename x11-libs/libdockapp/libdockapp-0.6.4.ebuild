# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools font

DESCRIPTION="Window Maker Dock Applet Library"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmclock"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
# Required for font eclass
IUSE="+X"
REQUIRED_USE="X"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/dockapps

FONT_S=${S}/fonts
FONT_SUFFIX="gz"
DOCS="README ChangeLog NEWS AUTHORS"

src_prepare()
{
	eautoreconf
}

src_configure()
{
	# Font installation handled by font eclass
	econf --without-font --without-examples
}

src_install()
{
	emake DESTDIR="${D}" install
	font_src_install
}
