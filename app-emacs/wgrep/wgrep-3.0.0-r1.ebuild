# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp readme.gentoo-r1

DESCRIPTION="Writable grep buffer and apply the changes to files"
HOMEPAGE="https://github.com/mhayashi1120/Emacs-wgrep/"
SRC_URI="https://github.com/mhayashi1120/Emacs-${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/Emacs-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/s
		app-emacs/dash
	)
"

ELISP_REMOVE="${PN}-subtest.el"

DOCS=( README.md )
DOC_CONTENTS="See commentary in ${SITELISP}/${PN}/wgrep.el for documentation.
	\n\nTo activate wgrep, add the following line to your ~/.emacs file:
	\n\t(require 'wgrep)"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	if ! use test ; then
		rm ${PN}-test.el || die
	fi

	elisp_src_prepare
}

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l ${PN}.el -l ${PN}-test.el    \
		-f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	if use test ; then
	   rm ${PN}-test.el{,c} || die
	fi

	elisp_src_install
}
