# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib

MY_P=${PN}-app-${PV}

DESCRIPTION="A file system viewer for Window Maker"
HOMEPAGE="http://wie-im-flug.net/linux/fsviewer/index.html"
SRC_URI="http://wie-im-flug.net/linux/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND=">=x11-wm/windowmaker-0.95.2
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-wmaker-0.95_support.patch
	"${FILESDIR}"/${P}-fix_title_bar.patch
	"${FILESDIR}"/${P}-gcc-10.patch
)
DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-appspath=/usr/$(get_libdir)/GNUstep
}

src_install() {
	default
	dosym ../$(get_libdir)/GNUstep/FSViewer.app/FSViewer /usr/bin/FSViewer
}
