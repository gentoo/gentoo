# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools-utils eutils elisp-common

DESCRIPTION="Namazu is a full-text search engine"
HOMEPAGE="http://www.namazu.org/"
SRC_URI="http://www.namazu.org/test/${P/_p/pre}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="emacs nls tk linguas_ja"

RDEPEND=">=dev-perl/File-MMagic-1.20
	emacs? ( virtual/emacs )
	linguas_ja? (
		app-i18n/nkf
		|| (
			dev-perl/Text-Kakasi
			app-i18n/kakasi
			app-text/chasen
			app-text/mecab
		)
	)
	nls? ( virtual/libintl )
	tk? (
		dev-lang/tk
		www-client/lynx
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
S="${WORKDIR}"/${P/_p/pre}

PATCHES=(
	"${FILESDIR}/${PN}-2.0.19-gentoo.patch"
)
DOCS=(AUTHORS CREDITS NEWS THANKS TODO)

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable tk tknamazu)
	)

	use tk && myeconfargs+=(
		--with-namazu=/usr/bin/namazu
		--with-mknmz=/usr/bin/mknmz
		--with-indexdir=/var/lib/namazu/index
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use emacs; then
		cd lisp
		elisp-compile gnus-nmz-1.el namazu.el
	fi
}

src_install () {
	autotools-utils_src_install
	dodoc ChangeLog* HACKING* README* etc/*.png
	dohtml -r doc/*
	rm -r "${ED}"/usr/share/namazu/doc || die
	if use emacs; then
		elisp-install ${PN} lisp/gnus-nmz-1.el* lisp/namazu.el*
		elisp-site-file-install "${FILESDIR}"/50${PN}-gentoo.el

		docinto lisp
		dodoc lisp/ChangeLog*
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
