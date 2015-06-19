# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/ngspice/ngspice-26.ebuild,v 1.3 2014/12/14 16:53:03 tomjbe Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="The Next Generation Spice (Electronic Circuit Simulator)"
SRC_URI="mirror://sourceforge/ngspice/${P}.tar.gz
	mirror://sourceforge/ngspice/${PN}-${PV}-manual.pdf"
HOMEPAGE="http://ngspice.sourceforge.net"
LICENSE="BSD GPL-2"

SLOT="0"
IUSE="X debug readline"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="sys-libs/ncurses
	readline? ( >=sys-libs/readline-5.0 )
	X? ( x11-libs/libXaw
		x11-libs/libXt
		x11-libs/libX11
		sci-visualization/xgraph )"

RDEPEND="$DEPEND"

src_prepare() {
	sed -e '/CFLAGS=/s: -s::' -i configure.ac || die "sed failed"
	sed -e 's/_CFLAGS -O2/_CFLAGS/' -i configure.ac || die "sed failed"
	sed -e 's/LDFLAGS =/LDFLAGS +=/' -i src/xspice/icm/makedefs.in || die "sed failed"
	sed -e '/AM_INIT_AUTOMAKE/s:-Werror::' -i configure.ac || die "sed failed"
	# builds also with ncurses[tinfo] (bug #458128)
	sed -e 's/ncurses termcap/ncurses termcap tinfo/g' -i configure.ac || die
	eautoreconf
}

src_configure() {
	local MYCONF
	if use debug ; then
		MYCONF="--enable-debug \
			--enable-ftedebug \
			--enable-cpdebug \
			--enable-asdebug \
			--enable-stepdebug \
			--enable-pzdebug"
	else
		MYCONF="--disable-debug \
			--disable-ftedebug \
			--disable-cpdebug \
			--disable-asdebug \
			--disable-stepdebug \
			--disable-pzdebug"
	fi
	# Those don't compile
	MYCONF="${MYCONF} \
		--disable-sensdebug \
		--disable-blktmsdebug \
		--disable-smltmsdebug"

	econf \
		${MYCONF} \
		--enable-xspice \
		--enable-cider \
		--enable-ndev \
		--disable-xgraph \
		--disable-dependency-tracking \
		--disable-rpath \
		$(use_with X x) \
		$(use_with readline)
}

# These will need to be looked at some day:
# --enable-adms
# --enable-nodelimiting
# --enable-predictor
# --enable-newtrunc
# --enable-openmp

src_install () {
	local infoFile
	for infoFile in doc/ngspice.info*; do
		echo 'INFO-DIR-SECTION EDA' >> ${infoFile}
		echo 'START-INFO-DIR-ENTRY' >> ${infoFile}
		echo '* NGSPICE: (ngspice). Electronic Circuit Simulator.' >> ${infoFile}
		echo 'END-INFO-DIR-ENTRY' >> ${infoFile}
	done

	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ANALYSES AUTHORS BUGS ChangeLog DEVICES NEWS \
		README Stuarts_Poly_Notes || die "failed to install documentation"

	insinto /usr/share/doc/${PF}
	doins "${DISTDIR}"/${PN}-${PV}-manual.pdf || die "failed to install manual"

	# We don't need ngmakeidx to be installed
	rm "${D}"/usr/bin/ngmakeidx
}

src_test () {
	# Bug 108405
	true
}
