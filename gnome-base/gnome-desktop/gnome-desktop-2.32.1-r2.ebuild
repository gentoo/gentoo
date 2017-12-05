# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-r1

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="https://www.gnome.org/"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="license-docs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Note: gnome-desktop:2 and :3 install identical files in /usr/share/gnome/help
# and /usr/share/omf when --enable-desktop-docs is passed to configure. To avoid
# file conflict and pointless duplication, gnome-desktop:2[doc] will simply use
# the files that are installed by :3[doc]
# Note: depend on glib-2.34 to make sure users upgrade glib before gnome-desktop
# to get a fix for bug #450930
RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.34:2
	>=x11-libs/libXrandr-1.2
	>=gnome-base/gconf-2:2
	>=x11-libs/startup-notification-0.5
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	x11-proto/xproto
	>=x11-proto/randrproto-1.2
"
PDEPEND=">=dev-python/pygtk-2.8:2[${PYTHON_USEDEP}]
	>=dev-python/pygobject-2.14:2[${PYTHON_USEDEP}]
	license-docs? ( gnome-base/gnome-desktop:3[doc(+)] )
"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

src_prepare() {
	epatch "${FILESDIR}"/${P}-gold.patch
	epatch "${FILESDIR}"/${P}-thumbnails.patch #450930
	gnome2_src_prepare
}

src_configure() {
	python_export_best
	gnome2_src_configure \
		--with-gnome-distributor=Gentoo \
		--disable-scrollkeeper \
		--disable-static \
		--disable-deprecations \
		--disable-desktop-docs
	# desktop-docs will be built by gnome-desktop:3
}

src_install() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	gnome2_src_install
	# python-r1.eclass doesn't like versioned python shebangs
	sed -e 's@#!\(.*python.*\)@#!/usr/bin/env python@' -i gnome-about/gnome-about
	python_doscript gnome-about/gnome-about
}
