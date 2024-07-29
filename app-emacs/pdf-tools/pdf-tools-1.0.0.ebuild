# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.3

inherit autotools elisp

DESCRIPTION="Emacs Lisp support library for PDF documents"
HOMEPAGE="https://github.com/vedang/pdf-tools/"
SRC_URI="https://github.com/vedang/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# Cask is a hard dependency for tests; it is ran by helper functions too.
RESTRICT="test"

BDEPEND="app-emacs/tablist"
DEPEND="
	app-text/poppler:=[cairo,png]
	dev-libs/glib:2=
	media-libs/freetype:2=
	media-libs/harfbuzz:=
	media-libs/libpng:=
	x11-libs/cairo:=
"
RDEPEND="
	${DEPEND}
	${BDEPEND}
"

DOCS=( NEWS README.org )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	cd server || die
	eautoreconf
}

src_configure() {
	cd server || die
	econf
}

src_compile() {
	BYTECOMPFLAGS="-L lisp" elisp-compile lisp/*.el
	elisp-make-autoload-file lisp/${PN}-autoloads.el lisp

	emake -C server
}

src_install() {
	elisp-install ${PN} lisp/*.el*
	elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	emake -C server DESTDIR="${D}" install

	einstalldocs
}
