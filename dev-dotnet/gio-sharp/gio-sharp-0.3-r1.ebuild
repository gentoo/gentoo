# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools mono-env

DESCRIPTION="GIO API C# binding"
HOMEPAGE="https://github.com/mono/gio-sharp"
SRC_URI="https://github.com/mono/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-dotnet/gtk-sharp-2.12.21
	>=dev-libs/glib-2.22:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	mono-env_pkg_setup
}

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	sed -i -e 's/gmcs/mcs/' configure.ac.in || die
	sed -i -e '/autoreconf/d' autogen-generic.sh || die
	NOCONFIGURE=1 ./autogen-2.22.sh || die

	eautoreconf
}

src_compile() {
	emake -j1
}
