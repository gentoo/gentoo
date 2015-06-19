# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtk-sharp-beans/gtk-sharp-beans-2.14.0.ebuild,v 1.5 2012/05/04 03:56:55 jdhore Exp $

EAPI=2
inherit autotools mono

DESCRIPTION="GTK+ API C# binding"
HOMEPAGE="http://github.com/mono/gtk-sharp-beans"
SRC_URI="http://github.com/mono/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-dotnet/gio-sharp
	>=dev-dotnet/glib-sharp-2.12
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gtk-sharp-gapi-2.12"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	eautoreconf
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README

	mono_multilib_comply
}
