# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="The Next Generation Spice (Electronic Circuit Simulator)"
SRC_URI="mirror://sourceforge/ngspice/${P}.tar.gz
	doc? ( mirror://sourceforge/ngspice/${P}-manual.pdf )"
HOMEPAGE="http://ngspice.sourceforge.net"
LICENSE="BSD GPL-2"

SLOT="0"
IUSE="X debug doc fftw openmp readline"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x64-macos"

DEPEND="X? ( x11-libs/libICE
		x11-libs/libXaw
		x11-libs/libXext
		x11-libs/libXmu )
		fftw? ( sci-libs/fftw:3.0 )"
RDEPEND="${DEPEND}
	X? ( sci-visualization/xgraph )"

DOCS=(
	ANALYSES
	AUTHORS
	BUGS
	ChangeLog
	DEVICES
	NEWS
	README
	Stuarts_Poly_Notes
)

PATCHES=(
	"${FILESDIR}"/${P}-autoconf_fftw3.patch
	"${FILESDIR}"/${P}-split_terminfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf
	if use debug ; then
		myconf="--enable-debug \
			--enable-ftedebug \
			--enable-cpdebug \
			--enable-sensdebug \
			--enable-asdebug \
			--enable-stepdebug \
			--enable-pzdebug"
	else
		myconf="--disable-debug \
			--disable-ftedebug \
			--disable-cpdebug \
			--disable-sensdebug \
			--disable-asdebug \
			--disable-stepdebug \
			--disable-pzdebug"
	fi
	# As of December 2017, these do not compile
	myconf="${myconf}
		--disable-blktmsdebug \
		--disable-smltmsdebug"

	econf \
		${myconf} \
		--enable-xspice \
		--enable-cider \
		--enable-ndev \
		--disable-xgraph \
		--disable-dependency-tracking \
		--disable-rpath \
		$(use_enable openmp) \
		$(use_with X x) \
		$(use_with fftw fftw3) \
		$(use_with readline)
}

src_install() {
	default

	# We don't need ngmakeidx to be installed
	rm -f "${D}"/usr/bin/ngmakeidx
	rm -f "${D}"/usr/share/man/man1/ngmakeidx.1

	use doc && dodoc "${DISTDIR}"/${P}-manual.pdf
}
