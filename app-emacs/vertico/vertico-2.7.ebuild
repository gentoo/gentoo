# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Vertical interactive completion"
HOMEPAGE="https://github.com/minad/vertico/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/minad/${PN}"
else
	SRC_URI="https://github.com/minad/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
"

DOCS=( CHANGELOG.org README.org )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	mv ./extensions/*.el ./ || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
