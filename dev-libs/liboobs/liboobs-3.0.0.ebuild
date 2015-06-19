# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liboobs/liboobs-3.0.0.ebuild,v 1.11 2015/04/03 10:41:28 dlan Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="Liboobs is a wrapping library to the System Tools Backends"
HOMEPAGE="http://library.gnome.org/devel/liboobs/stable/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ia64 ppc sparc x86"
IUSE=""

# FIXME: check if policykit should be checked in configure ?
RDEPEND="
	>=dev-libs/glib-2.14:2
	>=dev-libs/dbus-glib-0.70
	>=app-admin/system-tools-backends-2.10.1
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--without-hal \
		--disable-static
}
