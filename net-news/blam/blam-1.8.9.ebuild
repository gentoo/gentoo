# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/blam/blam-1.8.9.ebuild,v 1.6 2014/10/31 08:46:24 pacho Exp $

EAPI="4"
inherit mono eutils

DESCRIPTION="A RSS aggregator written in C#"
HOMEPAGE="http://blam.relatitude.org/"
SRC_URI="http://blam.relatitude.org/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-lang/mono-2
	>=dev-dotnet/gtk-sharp-2.12.6
	>=dev-dotnet/glade-sharp-2.12.6
	>=dev-dotnet/gnome-sharp-2.16.1
	>=dev-dotnet/gconf-sharp-2.8.2
	>=dev-dotnet/webkit-sharp-0.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/gconf-2.4"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.25"

# Disable parallel builds
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch "${FILESDIR}/${P}-use-elif.patch"
}

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog INSTALL NEWS README
	mono_multilib_comply
}
