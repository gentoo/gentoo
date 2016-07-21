# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Interface for the Collins Dictionary"
HOMEPAGE="http://toxygen.net/ydpdict/"
SRC_URI="http://toxygen.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ao"

RDEPEND=">=app-dicts/libydpdict-${PV}
	sys-libs/ncurses[unicode]
	ao? ( media-libs/libao )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_with ao libao)
}

src_install() {
	dodir "/etc"
	emake DESTDIR="${D}" install
	dodoc README
}

pkg_postinst() {
	echo
	elog "Note that to use this program you'll need the original Collins Dictionary"
	elog "datafiles (dict100.*, dict101.*). These can be found in the Dabasase/"
	elog "directory of the Windows version of the Collins dictionary. Once you obtain"
	elog "the files, put them into /usr/share/ydpdict"
	elog
	elog "Some configuration options can be set in /etc/ydpdict.conf"
	echo
}
