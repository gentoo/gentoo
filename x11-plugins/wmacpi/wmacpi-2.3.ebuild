# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmacpi/wmacpi-2.3.ebuild,v 1.1 2015/01/12 10:34:11 voyageur Exp $

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

DEPEND="x11-libs/libdockapp
	x11-libs/libX11"

S=${WORKDIR}/dockapps

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
}
