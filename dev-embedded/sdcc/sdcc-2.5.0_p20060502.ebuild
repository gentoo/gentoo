# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/sdcc/sdcc-2.5.0_p20060502.ebuild,v 1.7 2014/08/10 20:06:17 slyfox Exp $

inherit eutils

MY_PV=${PV/*_p/}
DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="http://sdcc.sourceforge.net/"
SRC_URI="http://sdcc.sourceforge.net/snapshots/sdcc-src/${PN}-src-${MY_PV}.tar.gz
	doc? ( http://sdcc.sourceforge.net/snapshots/docs/${PN}-doc-${MY_PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

DEPEND=">=dev-embedded/gputils-0.13.2
	dev-libs/boehm-gc"
RDEPEND="!dev-embedded/sdcc-svn
	!dev-embedded/sdcc-svn"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix conflicting variable names between Gentoo and sdcc
	find ./ -type f -exec sed -i s:PORTDIR:PORTINGDIR:g  {} \; || die "sed failed"
	find device/lib/pic*/ -type f -exec sed -i s:ARCH:SDCCARCH:g  {} \; || die "sed failed"
	find device/lib/pic/libdev/ -type f -exec sed -i s:CFLAGS:SDCCFLAGS:g  {} \; || die "sed failed"

	# --as-needed fix :
	sed -i -e "s/= @CURSES_LIBS@ @LIBS@/= @CURSES_LIBS@ @LIBS@ -lcurses/" sim/ucsim/gui.src/serio.src/Makefile.in || die "sed failed"
}

src_compile() {
	econf --enable-libgc docdir=/usr/share/doc/${PF} || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc ChangeLog
	if use doc ; then
		cp -pPR "${WORKDIR}"/doc/* "${D}"/usr/share/doc/${PF}/
	fi
	find "${D}"/usr/share/doc/${PF}/ -name *.txt -exec gzip -f -9 {} \;
	find "${D}"/usr/share/doc/${PF}/ -name */*.txt -exec gzip -f -9 {} \;
}
