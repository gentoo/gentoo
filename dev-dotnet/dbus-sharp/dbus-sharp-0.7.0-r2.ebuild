# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools mono-env eutils

DESCRIPTION="D-Bus for .NET"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="https://github.com/downloads/mono/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="1.0"
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
	sed -i -e 's/gmcs/mcs/' configure.ac || die
	eautoreconf
}
