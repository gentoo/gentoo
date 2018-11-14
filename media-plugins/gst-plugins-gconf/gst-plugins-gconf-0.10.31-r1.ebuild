# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gnome2-utils gstreamer

DESCRIPTION="GStreamer plugin for wrapping GConf audio/video settings"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=gnome-base/gconf-2.32.4-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gconf gconftool"

multilib_src_configure() {
	gstreamer_multilib_src_configure \
		--disable-schemas-install
}

multilib_src_compile() {
	gstreamer_multilib_src_compile

	if multilib_is_native_abi; then
		emake -C gconf
	fi
}

multilib_src_install() {
	gstreamer_multilib_src_install

	if multilib_is_native_abi; then
		emake -C gconf DESTDIR="${D}" install
	fi
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install
}
