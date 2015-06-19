# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/dconf/dconf-0.22.0.ebuild,v 1.10 2015/06/07 10:33:39 maekke Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 bash-completion-r1 virtualx

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="https://wiki.gnome.org/dconf"

LICENSE="LGPL-2.1+"
SLOT="0"

# TODO: coverage ?
IUSE="test X"

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~x86-fbsd ~arm-linux ~x86-linux"

RDEPEND="
	>=dev-libs/glib-2.39.1:2
	sys-apps/dbus
	X? (
		>=dev-libs/libxml2-2.7.7:2
		>=x11-libs/gtk+-3.4:3 )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-gcov \
		--enable-man \
		$(use_enable X editor) \
		VALAC=$(type -P true)
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install

	# GSettings backend may be one of: memory, gconf, dconf
	# Only dconf is really considered functional by upstream
	# must have it enabled over gconf if both are installed
	echo 'CONFIG_PROTECT_MASK="/etc/dconf"' >> 51dconf
	echo 'GSETTINGS_BACKEND="dconf"' >> 51dconf
	doenvd 51dconf

	# Install bash-completion file properly to the system
	rm -rv "${ED}usr/share/bash-completion" || die
	dobashcomp "${S}/bin/completion/dconf"
}

pkg_postinst() {
	gnome2_pkg_postinst
	# Kill existing dconf-service processes as recommended by upstream due to
	# possible changes in the dconf private dbus API.
	# dconf-service will be dbus-activated on next use.
	pids=$(pgrep -x dconf-service)
	if [[ $? == 0 ]]; then
		ebegin "Stopping dconf-service; it will automatically restart on demand"
		kill ${pids}
		eend $?
	fi
}
