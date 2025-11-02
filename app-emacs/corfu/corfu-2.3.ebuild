# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Completion Overlay Region FUnction"
HOMEPAGE="https://github.com/minad/corfu/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/minad/${PN}"
else
	SRC_URI="https://github.com/minad/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.1.0.0
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	mv ./extensions/*.el . || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
