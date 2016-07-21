# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit elisp-common eutils

DESCRIPTION="Fast, high-capacity, identifier database tool"
HOMEPAGE="https://www.gnu.org/software/idutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs nls"

RDEPEND="emacs? ( virtual/emacs )
	 nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

DOCS="AUTHORS ChangeLog NEWS README* THANKS TODO"

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.6-glibc-2.16.patch"
}

src_configure() {
	use emacs || export EMACS=no
	econf \
		$(use_enable nls) \
		$(use_with emacs lispdir "${SITELISP}/${PN}")
}
