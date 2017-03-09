# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit mono-env

DESCRIPTION="Managed D-Bus Implementation for .NET"
HOMEPAGE="http://www.ndesk.org/DBusSharp"
SRC_URI="http://www.ndesk.org/archive/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=dev-lang/mono-1.2.4
	>=sys-apps/dbus-1
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	# mono-4 compat
	sed -i "s#gmcs#mcs#g" configure || die
}
