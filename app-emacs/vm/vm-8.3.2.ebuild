# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools elisp

DESCRIPTION="The VM mail reader for Emacs"
HOMEPAGE="https://gitlab.com/emacs-vm/vm"
SRC_URI="https://gitlab.com/emacs-vm/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"

BDEPEND="sys-apps/texinfo"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-emacs="emacs" \
		--with-lispdir="${SITELISP}/${PN}" \
		--with-etcdir="${SITEETC}/${PN}" \
		--with-docdir="/usr/share/doc/${PF}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	# NEWS is accessed from lisp and must not be compressed
	docompress -x /usr/share/doc/${PF}/NEWS
}
