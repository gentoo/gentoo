# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A lightweight volume control that sits in your systray"
HOMEPAGE="http://softwarebakery.com/maato/volumeicon.html"
SRC_URI="http://softwarebakery.com/maato/files/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND=">=dev-libs/glib-2
	media-libs/alsa-lib
	x11-libs/gtk+:3
	x11-libs/libX11
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog"

PATCHES=(
	"${FILESDIR}"/${P}-fix-libnotify.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# $(use_enable !alsa oss) fails wrt #419891, is likely only for OSS4
	econf $(use_enable libnotify notify)
}
