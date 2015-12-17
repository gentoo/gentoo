# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="a popup menu of icons like in AfterStep, as a dockable application"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmmenu"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gdk-pixbuf[X]
	>=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"

S=${WORKDIR}/dockapps

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch

	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_compile() {
	emake  CC="$(tc-getCC)"
}

src_install() {
	dobin wmmenu
	doman wmmenu.1
	dodoc README TODO example/apps example/defaults example/extract_icon_back
}
