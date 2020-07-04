# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Tango icons for iPod Digital Audio Player devices and the Dell Pocket DJ DAP"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="png"
RESTRICT="binchecks strip"

RDEPEND="x11-themes/tango-icon-theme"
DEPEND="${RDEPEND}"
BDEPEND="
	gnome-base/librsvg
	virtual/imagemagick-tools[png?]
	virtual/pkgconfig
	x11-misc/icon-naming-utils"

PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable png png-creation) \
		$(use_enable png icon-framing)
}
