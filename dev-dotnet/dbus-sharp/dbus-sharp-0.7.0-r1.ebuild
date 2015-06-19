# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/dbus-sharp/dbus-sharp-0.7.0-r1.ebuild,v 1.6 2012/08/18 12:24:40 xmw Exp $

EAPI="4"
inherit mono eutils

DESCRIPTION="D-Bus for .NET"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="mirror://github/mono/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/mono
	sys-apps/dbus"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS README"
}

src_prepare() {
	# Fix signals, bug #387097
	epatch "${FILESDIR}/${P}-fix-signals.patch"
	epatch "${FILESDIR}/${P}-fix-signals2.patch"
}
