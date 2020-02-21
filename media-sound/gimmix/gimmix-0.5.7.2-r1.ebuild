# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="a graphical music player daemon (MPD) client using GTK+2"
HOMEPAGE="https://launchpad.net/gimmix"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cover lyrics taglib"

RDEPEND="
	media-libs/libmpd:=
	gnome-base/libglade:=
	x11-libs/gtk+:2
	cover? (
		net-libs/libnxml:=
		net-misc/curl:=
	)
	lyrics? (
		net-libs/libnxml:=
		net-misc/curl:=
	)
	taglib? ( media-libs/taglib:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/intltool"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.7.1-curl-headers.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${PN}-0.5.7.2-QA-desktop-file.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cover) \
		$(use_enable lyrics) \
		$(use_enable taglib tageditor)
}
