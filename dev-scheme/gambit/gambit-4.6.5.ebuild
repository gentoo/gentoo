# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/gambit/gambit-4.6.5.ebuild,v 1.2 2014/08/10 21:25:17 slyfox Exp $

EAPI="4"

inherit eutils elisp-common

MY_PN=gambc
MY_PV=${PV//./_}
MY_P=${MY_PN}-v${MY_PV}

DESCRIPTION="Gambit-C is a native Scheme to C compiler and interpreter"
HOMEPAGE="http://www.iro.umontreal.ca/~gambit/"
SRC_URI="http://www.iro.umontreal.ca/~gambit/download/gambit/v${PV%.*}/source/${MY_P}.tgz"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

DEPEND="emacs? ( virtual/emacs )"
RDEPEND=""

SITEFILE="50gambit-gentoo.el"

S=${WORKDIR}/${MY_P} #-devel

IUSE="emacs static"

src_configure() {
	econf $(use_enable !static shared) --docdir="${EPREFIX}"/usr/share/doc/${PF} --enable-single-host --disable-absolute-shared-libs
}

src_compile() {
	emake bootstrap || die

	if use emacs; then
		elisp-compile misc/*.el || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
