# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="a lightweight BibTeX editor"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfbib"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.12
	>=x11-libs/gtk+-2.10:2
	>=xfce-base/libxfce4ui-4.8
	>=xfce-base/libxfce4util-4.8"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${P}-validate.patch
		"${FILESDIR}"/${P}-libxfce4ui.patch
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

src_prepare() {
	# This is to prevent eautoreconfigure:
	sed -i -e 's:libxfcegui4-1.0:libxfce4ui-1:' configure || die
	sed -i -e 's:$(LIBXFCE4UTIL_CFLAGS):& $(LIBXFCEGUI4_CFLAGS):' src/Makefile.in || die

	xfconf_src_prepare
}
