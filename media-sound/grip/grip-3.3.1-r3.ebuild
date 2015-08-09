# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils flag-o-matic toolchain-funcs libtool

DESCRIPTION="GTK+ based Audio CD Player/Ripper"
HOMEPAGE="http://sourceforge.net/projects/grip/"
SRC_URI="mirror://sourceforge/grip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="nls vorbis"

RDEPEND=">=x11-libs/gtk+-2.2:2
	x11-libs/vte:0
	media-sound/lame
	media-sound/cdparanoia
	>=media-libs/id3lib-3.8.3
	>=gnome-base/libgnomeui-2.2.0
	>=gnome-base/orbit-2
	net-misc/curl
	vorbis? ( media-sound/vorbis-tools )"
# gnome-extra/yelp, see bug 416843
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-implicit-declaration.patch
	epatch "${FILESDIR}"/${P}-invalid-genre-size.patch #285105
	# fix include syntax for newer versions of bash
	sed -i '/[.] conftest[.]id3/s: c: ./c:' configure || die
	elibtoolize
}

src_configure() {
	# Bug #69536
	[[ $(tc-arch) == "x86" ]] && append-flags "-mno-sse"

	strip-linguas be bg ca de en en_CA en_GB en_US es fi fr hu it ja nl pl_PL pt_BR ru zh_CN zh_HK zh_TW

	econf \
		--disable-dependency-tracking \
		$(use_enable nls)
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS CREDITS ChangeLog README TODO
}
