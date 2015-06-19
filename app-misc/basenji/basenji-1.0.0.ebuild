# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/basenji/basenji-1.0.0.ebuild,v 1.4 2014/08/10 18:01:37 slyfox Exp $

EAPI="4"

inherit multilib versionator

DESCRIPTION="Basenji is a volume indexing tool designed for easy and fast indexing of volume collections"
HOMEPAGE="http://launchpad.net/basenji"
SRC_URI="http://launchpad.net/basenji/trunk/$(get_version_component_range 1-2)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	dev-dotnet/gio-sharp
	dev-dotnet/gtk-sharp
	dev-dotnet/gnome-sharp
	dev-dotnet/taglib-sharp
	media-libs/libextractor"

DEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}
	dev-dotnet/gnome-desktop-sharp
	sys-fs/udisks"

S="${WORKDIR}"

src_prepare() {
	sed -i -e "s/-pkg:mono-cairo/-r:Mono.Cairo/" Basenji/Makefile || die "sed failed."
}

src_configure() {
	./configure --prefix="${EPREFIX}/usr"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
