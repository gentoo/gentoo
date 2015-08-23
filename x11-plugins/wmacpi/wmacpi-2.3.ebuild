# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="DockApp ACPI status monitor for laptops"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmacpi"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -ppc -sparc ~x86"
IUSE=""

DEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11"

S=${WORKDIR}/dockapps

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
}
