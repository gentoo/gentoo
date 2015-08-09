# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gnome2-utils gst-plugins-good gst-plugins10

DESCRIPTION="GStreamer plugin for wrapping GConf audio/video settings"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=gnome-base/gconf-2"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gconf gconftool"

src_configure() {
	gst-plugins10_src_configure --disable-schemas-install
}

src_compile() {
	gst-plugins10_src_compile
	cd "${S}"/gconf
	default
}

src_install() {
	gst-plugins10_src_install
	cd "${S}"/gconf
	default
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install
}
