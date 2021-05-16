# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools mono-env

DESCRIPTION="C# binding for gkeyfile"
HOMEPAGE="https://launchpad.net/gkeyfile-sharp https://github.com/mono/gkeyfile-sharp"
SRC_URI="https://github.com/mono/${PN}/tarball/GKEYFILE_SHARP_0_1 -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-dotnet/gtk-sharp-2.12.21"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	mv configure.in configure.ac
	sed -i -e 's/gmcs/mcs/' configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS
}
