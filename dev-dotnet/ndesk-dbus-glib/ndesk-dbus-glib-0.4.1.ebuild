# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/ndesk-dbus-glib/ndesk-dbus-glib-0.4.1.ebuild,v 1.4 2012/11/28 20:52:38 ulm Exp $

EAPI=3
inherit mono multilib

DESCRIPTION="glib integration for DBus-Sharp"
HOMEPAGE="http://www.ndesk.org/DBusSharp"
SRC_URI="http://www.ndesk.org/archive/dbus-sharp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-1.2.4
		 >=dev-dotnet/ndesk-dbus-0.4"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
