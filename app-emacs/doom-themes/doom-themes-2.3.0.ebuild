# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Opinionated megapack of modern color-themes for GNU Emacs"
HOMEPAGE="https://github.com/doomemacs/themes/"
SRC_URI="https://github.com/doomemacs/themes/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/themes-${PV}

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
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
