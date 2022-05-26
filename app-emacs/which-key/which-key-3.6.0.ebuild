# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp readme.gentoo-r1

DESCRIPTION="Display the key bindings following your currently entered keys"
HOMEPAGE="https://github.com/justbur/emacs-which-key/"
SRC_URI="https://github.com/justbur/emacs-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org img )
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To enable \"which-key-mode\" globally,
	add the following to your init file:
	\n\t(which-key-mode)"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} -l ${PN}.el -l ${PN}-tests.el \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	elisp-install ${PN} ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	einstalldocs
	readme.gentoo_create_doc
}
