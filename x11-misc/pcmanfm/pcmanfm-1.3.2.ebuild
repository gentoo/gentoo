# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-${PV/_/}"
inherit xdg readme.gentoo-r1

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.18:2
	>=lxde-base/menu-cache-1.1.0-r1
	virtual/eject
	virtual/freedesktop-icon-theme
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	>=x11-libs/libfm-${PV}:=[gtk]
	x11-libs/libX11
	x11-libs/pango
	x11-misc/shared-mime-info
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc \
		--with-gtk=3 \
		$(use_enable debug)
}

src_install() {
	default

	local DOC_CONTENTS="PCmanFM can optionally support the menu://applications/
	location. You should install lxde-base/lxmenu-data for that functionality."
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
