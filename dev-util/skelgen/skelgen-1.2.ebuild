# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A Skeleton Source File Generator"
HOMEPAGE="http://www.fluidstudios.com/"
SRC_URI="http://www.fluidstudios.com/pub/FluidStudios/Tools/Fluid_Studios_Skeleton_Source_File_Generator-${PV}.zip"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""
S=${WORKDIR}/source

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	# Makefile uses $STRIPPER to strip executable, so use true
	# instead and let portage handle that.
	emake \
		COMPILER="$(tc-getCXX)" \
		COMPILER_OPTIONS="-c ${CXXFLAGS}" \
		LINKER="$(tc-getCXX) ${LDFLAGS}" \
		STRIPPER="true"
}

src_install() {
	dobin skelgen
	dodoc readme.txt
	dodoc macros/{common.macro,personal.macro,work.macro}
	dodoc templates/{default.{cpp,h},fluid.{cpp,h},gpl.{c,h},skelgen.{cpp,h}}
}
