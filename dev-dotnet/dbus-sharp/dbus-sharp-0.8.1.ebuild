# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools mono-env

DESCRIPTION="D-Bus for .NET"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="https://github.com/mono/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="2.0"
KEYWORDS="amd64 x86"

RDEPEND="dev-lang/mono
	sys-apps/dbus"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README )

pkg_setup() {
	mono-env_pkg_setup
}

src_prepare() {
	sed -i -e 's/gmcs/mcs/' configure.ac || die
	eautoreconf
}
