# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/engrampa/engrampa-1.8.0.ebuild,v 1.9 2015/07/12 13:25:06 patrick Exp $

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Engrampa archive manager for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="caja"

# GLib-GIO-ERROR **: Settings schema 'org.mate.caja.preferences' is not installed
#
# ... thus we depend on Caja regardless of the Caja USE flag. Patches welcome.
RDEPEND=">=x11-libs/gtk+-2.21.4:2
	>=dev-libs/glib-2.25.5:2
	>=dev-libs/json-glib-0.14:0
	x11-libs/gdk-pixbuf:2
	x11-libs/pango:0
	virtual/libintl:0
	|| ( >=mate-base/caja-1.8:0 >=mate-base/mate-file-manager-1.6:0 )
	!!app-arch/mate-file-archiver"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35:*
	dev-util/itstool:0
	>=mate-base/mate-common-1.6:0
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_prepare() {
	gnome2_src_prepare

	# Drop DEPRECATED flags as configure option doesn't do it, bug #385453
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		copy-n-paste/Makefile.am copy-n-paste/Makefile.in || die
}

src_configure() {
	gnome2_src_configure \
		--disable-run-in-place \
		--disable-packagekit \
		--disable-deprecations \
		--with-gtk=2.0 \
		$(use_enable caja caja-actions)
}

DOCS="AUTHORS HACKING MAINTAINERS NEWS README TODO"

pkg_postinst() {
	gnome2_pkg_postinst

	elog ""
	elog "${PN} is a frontend for several archiving utilities. If you want a"
	elog "particular achive format supported install the relevant package."
	elog
	elog "For example:"
	elog "  7-zip   : emerge app-arch/p7zip"
	elog "  ace     : emerge app-arch/unace"
	elog "  arj     : emerge app-arch/arj"
	elog "  cpio    : emerge app-arch/cpio"
	elog "  deb     : emerge app-arch/dpkg"
	elog "  iso     : emerge app-cdr/cdrtools"
	elog "  jar,zip : emerge app-arch/zip  or  emerge app-arch/unzip"
	elog "  lha     : emerge app-arch/lha"
	elog "  lzma    : emerge app-arch/xz-utils"
	elog "  lzop    : emerge app-arch/lzop"
	elog "  rar     : emerge app-arch/unrar"
	elog "  rpm     : emerge app-arch/rpm"
	elog "  unstuff : emerge app-arch/stuffit"
	elog "  zoo     : emerge app-arch/zoo"
}
