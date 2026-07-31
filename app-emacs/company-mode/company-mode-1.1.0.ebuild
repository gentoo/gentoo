# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="https://company-mode.github.io/
	https://github.com/company-mode/company-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/posframe-1.5.1
"
BDEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-company-icons-root.patch" )

SITEFILE="50${PN}-gentoo-r1.el"
DOCS=( CONTRIBUTING.md README.md NEWS.md )

src_prepare() {
	elisp_src_prepare
	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i company.el || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
	emake -C doc company.info
}

src_test() {
	# Command essentially pulled form the company-mode's Makefile.
	edo ${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} -l ./test/all.el \
		--eval "(ert-run-tests-batch-and-exit '(not (or (tag interactive) (tag gui))))"
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins -r icons
	doinfo doc/company.info
}
