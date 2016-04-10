# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools

DESCRIPTION="stoken - Software Token for Linux/UNIX"
HOMEPAGE="http://stoken.sourceforge.net/"
SRC_URI="http://github.com/cernekee/stoken/archive/v${PV}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_with gtk)
}

src_install() {
	default
	dodoc CHANGES COPYING.LIB README.md TODO
	doman stoken.1
	if use gtk ; then
		doman stoken-gui.1
	fi
}
