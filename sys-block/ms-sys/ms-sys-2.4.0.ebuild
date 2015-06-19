# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/ms-sys/ms-sys-2.4.0.ebuild,v 1.4 2015/01/26 10:09:01 ago Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A command-line program for writing Microsoft compatible boot records"
HOMEPAGE="http://ms-sys.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="linguas_sv"

DEPEND="sys-devel/gettext"
RDEPEND="virtual/libintl"

src_compile() {
	tc-export CC
	default
}

src_install() {
	local nls=""
	if ! use linguas_sv ; then
		nls='NLS_FILES='
	fi

	emake DESTDIR="${D}" MANDIR="/usr/share/man" \
		PREFIX="/usr" ${nls} install

	dodoc CHANGELOG CONTRIBUTORS FAQ README TODO
}
