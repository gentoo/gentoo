# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Minuscule client library for the Git forge APIs"
HOMEPAGE="https://magit.vc/manual/ghub/
	https://github.com/magit/ghub/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}.git"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org )
ELISP_TEXINFO="docs/ghub.texi"
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/compat-30.0.0.0
	>=app-emacs/treepy-0.1.2
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

src_prepare() {
	default

	mv lisp/*.el . || die
	rm ghub-pkg.el || die
}
