# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
WANT_AUTOMAKE="1.9"

inherit autotools eutils

MY_P="${P/6/5}"

DESCRIPTION="A Fast CJK (Chinese/Japanese/Korean) Console Environment"
HOMEPAGE="http://zhcon.sourceforge.net/"
SRC_URI="mirror://sourceforge/zhcon/${MY_P}.tar.gz
		mirror://sourceforge/zhcon/zhcon-0.2.5-to-0.2.6.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ggi gpm"

DEPEND="ggi? ( media-libs/libggi[X] )
	gpm? ( sys-libs/gpm )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${DISTDIR}"/zhcon-0.2.5-to-0.2.6.diff.gz
	epatch "${FILESDIR}"/${P}.sysconfdir.patch
	epatch "${FILESDIR}"/${P}.configure.in.patch
	epatch "${FILESDIR}"/${P}+gcc-4.3.patch
	epatch "${FILESDIR}"/${P}+linux-headers-2.6.26.patch
	epatch "${FILESDIR}"/${P}-curses.patch
	epatch "${FILESDIR}"/${P}-amd64.patch
	epatch "${FILESDIR}"/${P}-automagic-fix.patch
	epatch "${FILESDIR}"/${P}.make-fix.patch
	for f in $(grep -lir HAVE_GGI_LIB *); do
		sed -i -e "s/HAVE_GGI_LIB/HAVE_LIBGGI/" "${f}" || die "sed failed"
	done
	eautoreconf
}

src_configure() {
	econf $(use_with ggi) \
		$(use_with gpm) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README NEWS TODO THANKS || die
	dodoc README.BSD README.gpm README.utf8 || die
}
