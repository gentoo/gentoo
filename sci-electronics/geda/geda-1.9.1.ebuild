# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils fdo-mime gnome2-utils versionator

MY_PN=${PN}-gaf
MY_P=${MY_PN}-${PV}

DESCRIPTION="GPL Electronic Design Automation (gEDA):gaf core package"
HOMEPAGE="http://www.gpleda.org/"
SRC_URI="http://ftp.geda-project.org/${MY_PN}/unstable/v$(get_version_component_range 1-2)/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc examples nls stroke threads"

CDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/pango
	>=x11-libs/cairo-1.2.0
	x11-libs/gdk-pixbuf
	>=dev-scheme/guile-1.8:12[deprecated]
	nls? ( virtual/libintl )
	stroke? ( >=dev-libs/libstroke-0.5.1 )"

DEPEND="${CDEPEND}
	sys-apps/groff
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16 )"

RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

src_prepare() {
	append-libs -lgio-2.0
	if ! use doc ; then
		sed -i -e '/^SUBDIRS = /s/docs//' Makefile.in || die
	fi
	if ! use examples ; then
		sed -i -e 's/\texamples$//' Makefile.in || die
	fi
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable threads threads posix) \
		$(use_with stroke libstroke) \
		$(use_enable nls) \
		$(use_enable debug assert) \
		--disable-doxygen \
		--disable-rpath \
		--disable-update-xdg-database
}

src_test() {
	emake -j1 check
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
