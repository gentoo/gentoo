# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="FreeWnn-${PV/_alpha/-a0}"

DESCRIPTION="Network-Extensible Kana-to-Kanji Conversion System"
HOMEPAGE="http://freewnn.sourceforge.jp/
	http://www.freewnn.org/"
SRC_URI="mirror://sourceforge.jp/freewnn/59257/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="X ipv6"

DEPEND="X? ( x11-libs/libX11 x11-libs/libXmu x11-libs/libXt )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	#Change WNNOWNER to root so we don't need to add wnn user
	# and disable stripping of binary files
	sed -i -e "s/WNNOWNER = wnn/WNNOWNER = root/" \
		-e "s/@INSTPGMFLAGS@//" makerule.mk.in \
		-e "s/@LN_S@/ln -sf/" || die

	#bug #318593

	epatch "${FILESDIR}"/${P}-parallel-build.patch #517916

	# 542534
	sed -i -e "s/egrep -v/egrep -av/" kWnn/kdic/Makefile.in \
		cWnn/tdic/Makefile.in cWnn/cdic/Makefile.in \
		Wnn/pubdicplus/Makefile.in || die
}

src_configure() {
	econf \
		--disable-cWnn \
		--disable-kWnn \
		--without-termcap \
		$(use_with X x) \
		$(use_with ipv6)
}

src_install() {
	# install executables, libs ,dictionaries
	emake DESTDIR="${ED}" install || die
	# install man pages
	emake DESTDIR="${ED}" install.man || die
	# install docs
	dodoc ChangeLog* CONTRIBUTORS
	# install rc script
	newinitd "${FILESDIR}"/freewnn.initd freewnn
}
