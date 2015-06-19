# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tktray/tktray-1.3.9.ebuild,v 1.3 2015/05/21 13:28:54 ago Exp $

EAPI=5

inherit eutils virtualx

MY_P="${PN}${PV}"

DESCRIPTION="System Tray Icon Support for Tk on X11"
HOMEPAGE="https://code.google.com/p/tktray/"
SRC_URI="https://tktray.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="debug threads test"

DEPEND="
	>=dev-lang/tcl-8.4:0=
	>=dev-lang/tk-8.4:0=
	x11-libs/libXext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/1.1-ldflags.patch
}

src_configure() {
	source /usr/lib/tclConfig.sh
	CPPFLAGS="-I${TCL_SRC_DIR}/generic ${CPPFLAGS}" \
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads)
}

src_test() {
	Xemake
}
