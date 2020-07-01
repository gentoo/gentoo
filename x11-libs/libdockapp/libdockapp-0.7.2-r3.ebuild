# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools font

DESCRIPTION="Window Maker Dock Applet Library"
HOMEPAGE="https://www.dockapps.net/libdockapp"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
# X equired for font eclass
IUSE="+X static-libs"
REQUIRED_USE="X"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

FONT_S=${S}/fonts
FONT_SUFFIX="gz"
DOCS="README ChangeLog NEWS AUTHORS"
PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare()
{
	default
	eautoreconf
}

src_configure()
{
	# Font installation handled by font eclass
	econf \
		$(use_enable static-libs static) \
		--without-font \
		--without-examples
}

src_install()
{
	emake DESTDIR="${D}" install
	font_src_install
}
