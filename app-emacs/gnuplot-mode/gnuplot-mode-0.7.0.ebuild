# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Gnuplot mode for Emacs"
HOMEPAGE="http://xafs.org/BruceRavel/GnuplotMode"
SRC_URI="https://github.com/bruceravel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc"

DEPEND="doc? ( virtual/latex-base )"
RDEPEND="sci-visualization/gnuplot[-emacs(-)]"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf \
		EMACS="${EMACS}" \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}"
}

src_compile() {
	emake
	use doc && emake pdf
}

src_install() {
	emake DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc README.org
	use doc && dodoc gpelcard.pdf

	DOC_CONTENTS="Please see ${SITELISP}/${PN}/gnuplot.el for the
		complete documentation."
	readme.gentoo_create_doc
}
