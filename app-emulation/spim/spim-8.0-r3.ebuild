# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="MIPS Simulator"
HOMEPAGE="http://spimsimulator.sourceforge.net/"
SRC_URI="http://www.cs.wisc.edu/~larus/SPIM/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc X"

RDEPEND="
	X? (
		media-fonts/font-adobe-100dpi
		x11-libs/libXaw
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	sys-devel/bison
	X? ( x11-misc/imake )
"

# test hangs forever, disabling it
RESTRICT="test"

src_prepare() {
	# fix bug #240005 and bug #243588
	eapply "${FILESDIR}/${P}-r1-respect_env.patch"

	# fix bug #330389
	sed -i -e 's:-12-\*-75-:-14-\*-100-:g' xspim/xspim.c || die

	default
}

src_configure() {
	tc-export CC
	emake -C spim configuration

	if use X; then
		emake -C xspim configuration
	fi
}

src_compile() {
	emake DESTDIR="${EPREFIX}" -C spim

	if use X; then
		emake DESTDIR="${EPREFIX}" EXCEPTION_DIR=/var/lib/spim \
			-C xspim -j1 xspim
	fi
}

src_test() {
	emake -C spim test
}

src_install() {
	emake DESTDIR="${ED}" -C spim install
	newman Documentation/spim.man spim.1

	if use X; then
		emake DESTDIR="${ED}" -C xspim install
		newman Documentation/xspim.man xspim.1
	fi

	doicon "${FILESDIR}"/xspim.svg
	make_desktop_entry xspim xSPIM xspim "ComputerScience;Science;Education"

	dodoc Documentation/SPIM.html
	dodoc ChangeLog Documentation/BLURB README VERSION
	if use doc ; then
		dodoc Documentation/TeX/{cycle,spim}.ps
	fi
}
