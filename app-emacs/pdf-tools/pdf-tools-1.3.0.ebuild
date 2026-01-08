# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp

DESCRIPTION="Emacs Lisp support library for PDF documents"
HOMEPAGE="https://github.com/vedang/pdf-tools/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/vedang/${PN}"
else
	SRC_URI="https://github.com/vedang/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	app-emacs/tablist
"
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

ELISP_REMOVE="
	test/pdf-loader-test.el
	test/pdf-view-test.el
"
PATCHES=(
	"${FILESDIR}/pdf-tools-1.3.0-test-helper.patch"
)

DOCS=( NEWS README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test

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
	local BYTECOMPFLAGS="-L lisp" elisp-compile lisp/*.el
	elisp-make-autoload-file lisp/${PN}-autoloads.el lisp

	emake -C server
}

src_test() {
	local -x PACKAGE_TAR="${T}/package_tar.tar"
	elisp_src_test
}

src_install() {
	elisp-install ${PN} lisp/*.el*
	elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	emake -C server DESTDIR="${D}" install
	einstalldocs
}
