# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp autotools readme.gentoo-r1

DESCRIPTION="emacs-w3m is an interface program of w3m on Emacs"
HOMEPAGE="http://emacs-w3m.namazu.org/
	https://github.com/emacs-w3m/emacs-w3m/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emacs-w3m/emacs-w3m.git"
else
	[[ ${PV} == *_p20230801 ]] &&
		COMMIT="1388eadc914bed79b0e06a6565388c5e8aff8014"
	SRC_URI="https://github.com/emacs-w3m/emacs-w3m/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="gzip-el l10n_ja"

RDEPEND="virtual/w3m"
BDEPEND="${RDEPEND}"

SITEFILE="70${PN}-gentoo.el"

src_prepare() {
	sed -i -e '/^configure:/,+2d' Makefile.in || die

	default
	eautoreconf
}

src_configure() {
	econf --without-compress-install
}

src_compile() {
	emake all-en $(use l10n_ja && echo all-ja)
}

src_install() {
	emake lispdir="${ED}${SITELISP}/${PN}" \
		COMPRESS_INSTALL=$(usex gzip-el) \
		install-lisp
	emake infodir="${ED}/usr/share/info" \
		ICONDIR="${ED}${SITEETC}/${PN}" \
		install-info-en $(use l10n_ja && echo install-info-ja) install-icons

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog* NEWS README
	use l10n_ja && dodoc BUGS.ja NEWS.ja README.ja

	DOC_CONTENTS="If you want to use the shimbun library, please emerge
		app-emacs/apel and app-emacs/flim."
	readme.gentoo_create_doc
}
