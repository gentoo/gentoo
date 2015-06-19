# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/bbdb/bbdb-3.1.2.ebuild,v 1.1 2014/07/28 16:33:40 ulm Exp $

EAPI=5

inherit elisp autotools

DESCRIPTION="The Insidious Big Brother Database"
HOMEPAGE="http://savannah.nongnu.org/projects/bbdb/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ GPL-1+ FDL-1.3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="tex vm"

DEPEND="tex? ( virtual/tex-base )
	vm? ( app-emacs/vm )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo-${PV}.el"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-init.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		"$(use_with vm vm-dir "${EPREFIX}${SITELISP}/vm")"
}

src_compile() {
	emake -C lisp
}

src_install() {
	emake -C lisp DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo doc/*.info*
	dodoc AUTHORS ChangeLog NEWS README TODO

	if use tex; then
		insinto "${TEXMF}"/tex/plain/${PN}
		doins tex/*.tex
	fi
}

pkg_postinst() {
	elisp-site-regen
	use tex && texconfig rehash
}

pkg_postrm() {
	elisp-site-regen
	use tex && texconfig rehash
}
