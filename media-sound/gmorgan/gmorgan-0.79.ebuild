# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Opensource software rhythm station"
HOMEPAGE="http://gmorgan.sourceforge.net/"
SRC_URI="mirror://sourceforge/gmorgan/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="media-libs/alsa-lib
	x11-libs/fltk:1"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-remove-gettext-version-check.patch
	"${FILESDIR}"/${P}-manpages.patch
	"${FILESDIR}"/${P}-remove-dirs.patch
	"${FILESDIR}"/${P}-remove-old-docs.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	default
	doman man/${PN}.1
}
