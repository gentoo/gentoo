# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Minor mode for performing structured editing of S-expressions"
HOMEPAGE="https://paredit.org/
	https://www.emacswiki.org/emacs/ParEdit/
	https://github.com/emacsmirror/paredit/"
SRC_URI="https://github.com/emacsmirror/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

DOCS=( CREDITS NEWS ${PN}.html )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile

	sh ./genhtml.sh || die "the script genhtml.sh failed"
}

src_test() {
	${EMACS} ${EMACSFLAGS} -l ${PN}.el -l test.el || die "tests failed"
}

src_install() {
	rm test.el* || die

	elisp_src_install
}
