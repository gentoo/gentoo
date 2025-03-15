# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Interactive macro-expander for Emacs"
HOMEPAGE="https://github.com/joddie/macrostep/
	https://github.com/emacsorphanage/macrostep/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacsorphanage/${PN}"
else
	SRC_URI="https://github.com/emacsorphanage/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.0.2.0
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
	rm ./macrostep-test.el{,c} || die

	elisp_src_install
}
