# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="A full-featured scriptable IRC client for the Emacs text editor"
HOMEPAGE="http://www.zenirc.org/"
SRC_URI="ftp://ftp.zenirc.org/pub/zenirc/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	# econf won't work because of unknown options
	./configure --prefix="${EPREFIX}/usr/" || die "configure failed"
}

src_compile() {
	default
}

src_install() {
	elisp-install ${PN} src/*.el src/*.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo doc/zenirc.info
	dodoc BUGS INSTALL NEWS README TODO

	cd doc
	docinto doc
	dodoc 666.conspiracy FAQ README-OLD ctcp.doc irc-operators \
		server-list tao-of-irc tour.of.irc undernet

	DOC_CONTENTS="Refer to the Info documentation and
		${SITELISP}/${PN}/zenirc-example.el for customization hints."
	readme.gentoo_create_doc
}
