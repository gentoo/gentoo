# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-do-plugins/gnome-do-plugins-0.8.5.ebuild,v 1.1 2014/11/22 18:05:49 pacho Exp $

EAPI=5
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 mono-env versionator

MY_PN="do-plugins"
PVC=$(get_version_component_range 1-3)

DESCRIPTION="Plugins to put the Do in Gnome Do"
HOMEPAGE="https://launchpad.net/do-plugins"
SRC_URI="https://launchpad.net/${MY_PN}/trunk/${PVC}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="banshee"

RDEPEND="
	>=gnome-extra/gnome-do-0.9
	dev-dotnet/wnck-sharp
	banshee? ( >=media-sound/banshee-1.4.2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Skip failing plugins (from ArchLinux)
	sed -i -e '/DiskMounter/d
		/Transmission/d' Makefile.am || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use banshee) \
		--disable-empathy \
		--disable-flickr \
		--disable-transmission
}

src_compile() {
	# The make system is unfortunately broken for parallel builds and
	# upstream indicated on IRC that they have no intention to fix
	# that.
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_compile
}
