# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=ff26f26ea3d761375f5fc4070438fbd0f3473d33

inherit elisp

DESCRIPTION="Opinionated megapack of modern color-themes for GNU Emacs"
HOMEPAGE="https://github.com/doomemacs/themes/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/doomemacs/themes.git"
else
	SRC_URI="https://github.com/doomemacs/themes/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/themes-${COMMIT}"

	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake test
}

src_install() {
	elisp_src_install

	insinto "${SITELISP}"/${PN}
	doins -r themes
}
