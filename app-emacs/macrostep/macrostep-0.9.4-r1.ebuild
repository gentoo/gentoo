# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Interactive macro-expander for Emacs"
HOMEPAGE="https://github.com/joddie/macrostep/
	https://github.com/emacsorphanage/macrostep/"
SRC_URI="https://github.com/emacsorphanage/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-test.patch" )

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . --load "${PN}-test.el" || die "test failed"
}

src_install() {
	rm macrostep-test.el{,c} || die

	elisp_src_install
}
