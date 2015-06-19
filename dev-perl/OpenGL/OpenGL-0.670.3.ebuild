# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/OpenGL/OpenGL-0.670.3.ebuild,v 1.2 2014/07/30 16:50:20 zlogene Exp $

EAPI=5

MODULE_AUTHOR="CHM"
MODULE_VERSION=0.6703

inherit perl-module eutils

DESCRIPTION="Perl interface providing graphics display using OpenGL"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	media-libs/freeglut:0=
	x11-libs/libICE:0=
	x11-libs/libXext:0=
	x11-libs/libXi:0=
	x11-libs/libXmu:0="
DEPEND="${RDEPEND}"

mydoc="Release_Notes"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.66-no-display.patch
}

src_compile() {
	sed -i -e 's/PERL_DL_NONLAZY=1//' Makefile || die
	perl-module_src_compile
}
