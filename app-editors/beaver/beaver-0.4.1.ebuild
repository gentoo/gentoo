# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic gnome2-utils

DESCRIPTION="Beaver is an Early AdVanced EditoR"
HOMEPAGE="http://beaver-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/beaver-editor/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND=">=dev-libs/glib-2.14:2
	>=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4.1-desktop-file-validate.patch
}

src_configure() {
	append-cflags -fgnu89-inline

	econf \
		$(use_enable doc doxygen-doc) \
		$(use_enable debug)
}

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_install() {
	default
	prune_libtool_files
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
