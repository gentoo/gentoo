# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
inherit autotools-utils eutils elisp-common

DESCRIPTION="Namazu is a full-text search engine"
HOMEPAGE="http://www.namazu.org/"
SRC_URI="http://www.namazu.org/test/${P/_p/pre}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="emacs nls tk l10n_ja"

RDEPEND=">=dev-perl/File-MMagic-1.20
	emacs? ( virtual/emacs )
	l10n_ja? (
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
		dev-lang/tk:0
		www-client/lynx
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
S="${WORKDIR}"/${P/_p/pre}

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable tk tknamazu)
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
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
