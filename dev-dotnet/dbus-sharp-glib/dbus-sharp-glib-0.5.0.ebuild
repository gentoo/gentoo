# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/dbus-sharp-glib/dbus-sharp-glib-0.5.0.ebuild,v 1.7 2012/05/04 03:56:56 jdhore Exp $

EAPI=4
inherit mono

DESCRIPTION="D-Bus for .NET: GLib integration module"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="mirror://github/mono/dbus-sharp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/mono
	>=dev-dotnet/dbus-sharp-0.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS README"
}
