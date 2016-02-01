# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils toolchain-funcs

DESCRIPTION="MIPS Simulator"
HOMEPAGE="http://spimsimulator.sourceforge.net/"
SRC_URI="http://www.cs.wisc.edu/~larus/SPIM/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc X"

RDEPEND="X? ( media-fonts/font-adobe-100dpi
	x11-libs/libXaw
	x11-libs/libXp )"
DEPEND="${RDEPEND}
	X? ( x11-misc/imake
		x11-proto/xproto )
	>=sys-apps/sed-4
	sys-devel/bison"
# test hangs forever, disabling it
RESTRICT="test"

src_prepare() {
	# fix bugs 240005 and 243588
	epatch "${FILESDIR}/${PF}-respect_env.patch"

	#fix bug 330389
	sed -i -e 's:-12-\*-75-:-14-\*-100-:g' xspim/xspim.c || die
}

src_configure() {
	tc-export CC
	emake -C spim configuration || die

	if use X; then
		emake -C xspim configuration || die
	fi
}

src_compile() {
	emake DESTDIR="${EPREFIX}" -C spim || die

	if use X; then
		emake DESTDIR="${EPREFIX}" EXCEPTION_DIR=/var/lib/spim \
			-C xspim -j1 xspim || die
	fi
}

src_install() {
	emake DESTDIR="${ED}" -C spim install || die
	newman Documentation/spim.man spim.1 || die

	if use X; then
		emake DESTDIR="${ED}" -C xspim install || die
		newman Documentation/xspim.man xspim.1 || die
	fi

	doicon "${FILESDIR}"/xspim.svg || die
	make_desktop_entry xspim xSPIM xspim "ComputerScience;Science;Education"

	dohtml Documentation/SPIM.html || die
	dodoc ChangeLog Documentation/BLURB README VERSION || die
	if use doc ; then
		dodoc Documentation/TeX/{cycle,spim}.ps || die
	fi
}

src_test() {
	emake -C spim test || die
}
