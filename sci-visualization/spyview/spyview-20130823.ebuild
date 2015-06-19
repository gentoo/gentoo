# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/spyview/spyview-20130823.ebuild,v 1.5 2014/01/23 16:12:13 dilfridge Exp $

EAPI=5

inherit autotools flag-o-matic eutils multilib

DESCRIPTION="Interactive plotting program"
HOMEPAGE="http://kavli.nano.tudelft.nl/~gsteele/spyview/"
SRC_URI="http://nsweb.tn.tudelft.nl/gitweb/?p=spyview.git;a=snapshot;h=879615fcc662e8572f99854557010d014bb4651e;sf=tgz -> $P.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/boost:=
	media-libs/netpbm
	x11-libs/fltk:1[opengl]
	app-text/ghostscript-gpl
	virtual/glu
"

DEPEND="${COMMON_DEPEND}
	sys-apps/groff"

RDEPEND="${COMMON_DEPEND}
	sci-visualization/gnuplot"

src_unpack() {
	default
	mv -v "${WORKDIR}"/spyview-* "${S}" || die
}

src_prepare() {
	append-cflags $(fltk-config --cflags)
	append-cxxflags $(fltk-config --cxxflags) -I/usr/include/netpbm

	# append-ldflags $(fltk-config --ldflags)
	# this one leads to an insane amount of warnings
	append-ldflags -L$(dirname $(fltk-config --libs))

	find "${S}" -name Makefile.am -exec sed -i -e 's:-mwindows -mconsole::g' {} + || die

	eautoreconf
}

src_configure() {
	econf --datadir=/usr/share/spyview --docdir=/usr/share/doc/${PF}
}
