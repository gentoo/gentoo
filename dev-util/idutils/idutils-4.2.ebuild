# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils elisp-common

DESCRIPTION="Fast, high-capacity, identifier database tool"
HOMEPAGE="https://www.gnu.org/software/idutils/"
DEB_PN="id-utils" # old upstream name for it
DEB_P="${DEB_PN}_${PV}"
DEB_PR="1"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
		mirror://debian/pool/main/${PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="emacs nls"

RDEPEND="emacs? ( virtual/emacs )
		 nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
		nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	epatch "${DISTDIR}"/${DEB_P}-${DEB_PR}.diff.gz
	epatch "${S}"/debian/patches/*.dpatch
}

src_compile() {
	use emacs || export EMACS=no
	econf \
		$(use_enable nls) \
		"$(use_with emacs lispdir "${SITELISP}/${PN}")"
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README* ChangeLog AUTHORS THANKS TODO
}
