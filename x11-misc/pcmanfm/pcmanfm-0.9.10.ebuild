# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools fdo-mime

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

KEYWORDS="~alpha amd64 arm ppc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.22.1:2
	>=lxde-base/menu-cache-0.3.2
	>=x11-libs/libfm-0.1.16"
RDEPEND="${COMMON_DEPEND}
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# Fix desktop icons
	sed -i -e "/MimeType/s:=.*normal;:=:" "${S}"/data/${PN}.desktop \
		|| die "failed to fix desktop icon"
	# drop -O0 -g. Bug #382265 and #382265
	sed -i -e "s:-O0::" -e "/-DG_ENABLE_DEBUG/s: -g::" "${S}"/configure.ac || die
	#Remove -Werror for automake-1.12. Bug #421101
	sed -i "s:-Werror::" configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}/etc" \
		$(use_enable debug)
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog 'PCmanFM can optionally support the menu://applications/ location.'
	elog 'You should install lxde-base/lxmenu-data for that	functionality.'
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
