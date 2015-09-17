# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools mono-env eutils

DESCRIPTION="D-Bus for .NET"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="https://github.com/mono/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-lang/mono
	sys-apps/dbus"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS README"
	mono-env_pkg_setup
}

src_prepare() {
	sed -i -e 's/gmcs/mcs/' configure.ac || die
	eautoreconf
}
