# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit mono multilib

DESCRIPTION="A generic framework for creating extensible applications"
HOMEPAGE="http://www.mono-project.com/Mono.Addins"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="+gtk"

RDEPEND=">=dev-lang/mono-2
	gtk? (  >=dev-dotnet/gtk-sharp-2.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable gtk gui)
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	mono_multilib_comply
}
