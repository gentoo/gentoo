# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-themes-standard/gnome-themes-standard-3.14.2.3-r2.ebuild,v 1.6 2015/07/17 15:43:53 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 multilib-minimal

DESCRIPTION="Standard Themes for GNOME Applications"
HOMEPAGE="https://git.gnome.org/browse/gnome-themes-standard/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+gtk"
KEYWORDS="~alpha amd64 arm ~arm64 ia64 ~mips ~ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-solaris ~x86-solaris"

COMMON_DEPEND="
	gnome-base/librsvg:2[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]
	gtk? (
		>=x11-libs/gtk+-2.24.15:2[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-3.12:3[${MULTILIB_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
# gnome-themes{,-extras} are OBSOLETE for GNOME 3
# http://comments.gmane.org/gmane.comp.gnome.desktop/44130
# Depend on gsettings-desktop-schemas-3.4 to make sure 3.2 users don't lose
# their default background image
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gsettings-desktop-schemas-3.4
	!<x11-themes/gnome-themes-2.32.1-r1
"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=746920
	epatch "${FILESDIR}/${PN}-3.14.2.3-srcdir.patch"
	eautoreconf

	gnome2_src_prepare
}

multilib_src_configure() {
	# The icon cache needs to be generated in pkg_postinst()
	ECONF_SOURCE="${S}" \
	gnome2_src_configure \
		--disable-static \
		$(use_enable gtk gtk2-engine) \
		$(use_enable gtk gtk3-engine) \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}

emake_engines_only() {
	pushd themes/Adwaita/gtk-2.0 > /dev/null || die
	if [[ $1 = install ]]; then
		emake DESTDIR="${D}" install-engineLTLIBRARIES
	else
		emake libadwaita.la
	fi
	popd > /dev/null
}

multilib_src_compile() {
	# processing >3500 icons is slow on old hard drives, do it only for native ABI
	if multilib_is_native_abi; then
		gnome2_src_compile
	elif use gtk; then
		emake_engines_only
	fi
}

multilib_src_install() {
	# processing >3500 icons is slow on old hard drives, do it only for native ABI
	if multilib_is_native_abi; then
		gnome2_src_install
	elif use gtk; then
		emake_engines_only install
		prune_libtool_files --modules
	fi
}
