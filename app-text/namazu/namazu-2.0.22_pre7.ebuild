# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools elisp-common

MY_P="${P/_pre/pre}"

DESCRIPTION="Namazu is a full-text search engine"
HOMEPAGE="http://www.namazu.org/"
SRC_URI="http://www.namazu.org/test/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="emacs l10n_ja nls static-libs tk"

RDEPEND="dev-perl/File-MMagic
	emacs? ( >=app-editors/emacs-23.1:* )
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
S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )

src_prepare() {
	default

	mv configure.{in,ac}
	mv tk${PN}/configure.{in,ac}
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable tk tk${PN})
	)
	use tk && myconf+=(
		--with-${PN}="${EPREFIX}"/usr/bin/${PN}
		--with-mknmz="${EPREFIX}"/usr/bin/mknmz
		--with-indexdir="${EPREFIX}"/var/lib/${PN}/index
	)

	econf "${myconf[@]}"
}

src_compile() {
	emake

	if use emacs; then
		cd lisp
		rm -f browse*
		elisp-compile *.el
	fi
}

src_test() {
	emake -j1 check
}

src_install () {
	default
	find "${ED}" -name '*.la' -delete || die

	if use emacs; then
		elisp-install ${PN} lisp/*.el*
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
