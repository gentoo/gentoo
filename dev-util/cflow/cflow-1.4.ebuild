# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cflow/cflow-1.4.ebuild,v 1.1 2013/05/27 06:07:23 dev-zero Exp $

EAPI="5"

inherit elisp-common eutils

DESCRIPTION="C function call hierarchy analyzer"
HOMEPAGE="http://www.gnu.org/software/cflow/"
SRC_URI="ftp://download.gnu.org.ua/pub/release/cflow/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug emacs nls"

RDEPEND="emacs? ( virtual/emacs )
	nls? ( virtual/libintl virtual/libiconv )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${P}-info-direntry.patch"
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable debug) \
		EMACS=no
}

src_compile() {
	default

	if use emacs; then
		elisp-compile elisp/cflow-mode.el
	fi
}

src_install() {
	default
	doinfo doc/cflow.info

	if use emacs; then
		elisp-install ${PN} elisp/cflow-mode.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
