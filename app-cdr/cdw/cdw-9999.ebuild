# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ECVS_SERVER="cdw.cvs.sourceforge.net:/cvsroot/cdw"
ECVS_MODULE="cdw"
ECVS_TOPDIR="${DISTDIR}/cvs-src/${ECVS_MODULE}"

inherit autotools cvs toolchain-funcs

DESCRIPTION="An ncurses based console frontend for cdrtools and dvd+rw-tools"
HOMEPAGE="http://cdw.sourceforge.net"

LICENSE="GPL-2+"
SLOT="0"
DOCS=( AUTHORS ChangeLog NEWS README THANKS cdw.conf )

RDEPEND="
	app-cdr/dvd+rw-tools
	dev-libs/libburn
	dev-libs/libcdio:=[-minimal]
	sys-libs/ncurses:0=[unicode]
	virtual/cdrtools
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/${ECVS_MODULE}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}
