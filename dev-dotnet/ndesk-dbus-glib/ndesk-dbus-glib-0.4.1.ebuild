# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mono-env

DESCRIPTION="glib integration for DBus-Sharp"
HOMEPAGE="http://www.ndesk.org/DBusSharp"
SRC_URI="http://www.ndesk.org/archive/dbus-sharp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=dev-lang/mono-1.2.4
	>=dev-dotnet/ndesk-dbus-0.4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	# mono-4 compat
	sed -i "s#gmcs#mcs#g" configure || die
}
