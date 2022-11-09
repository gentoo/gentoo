# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Interactive macro-expander for Emacs"
HOMEPAGE="https://github.com/joddie/macrostep/"
SRC_URI="https://github.com/joddie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org )
PATCHES=( "${FILESDIR}"/${PN}-test.patch )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . --load ${PN}-test.el || die "test failed"
}

src_install() {
	rm macrostep-test.el{,c} || die

	elisp_src_install
}
