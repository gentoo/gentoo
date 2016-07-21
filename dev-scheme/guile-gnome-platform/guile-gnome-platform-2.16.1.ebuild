# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit autotools eutils multilib

DESCRIPTION="Guile Scheme code that wraps the GNOME developer platform"
HOMEPAGE="https://www.gnu.org/software/guile-gnome"
SRC_URI="https://ftp.gnu.org/pub/gnu/guile-gnome/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-scheme/guile-1.6.4
	>=dev-libs/g-wrap-1.9.11
	dev-scheme/guile-cairo
	dev-libs/atk
	gnome-base/libbonobo
	gnome-base/orbit:2
	>=gnome-base/gconf-2.18:2
	>=dev-libs/glib-2.10:2
	>=gnome-base/gnome-vfs-2.16:2
	>=x11-libs/gtk+-2.10:2
	>=gnome-base/libglade-2.6:2.0
	>=gnome-base/libgnomecanvas-2.14
	>=gnome-base/libgnomeui-2.16
	>=x11-libs/pango-1.14
	dev-scheme/guile-lib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

#needs guile with networking
RESTRICT=test

src_prepare() {
	epatch "${FILESDIR}/${PV}-conflicting-types.patch"
	epatch "${FILESDIR}/${PV}-gcc45.patch"
	epatch "${FILESDIR}/${PV}-glib-single-include.patch"
	eautoreconf
}

src_configure() {
	econf --disable-Werror
}

src_compile() {
	emake -j1 guilegnomedir=/usr/share/guile/site \
		guilegnomelibdir=/usr/$(get_libdir) || die "emake failed."
}

src_install() {
	emake -j1 DESTDIR="${D}" \
		guilegnomedir=/usr/share/guile/site \
		guilegnomelibdir=/usr/$(get_libdir) \
		install || die "emake install failed."
}
