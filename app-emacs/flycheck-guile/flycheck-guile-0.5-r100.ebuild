# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )

inherit elisp guile-single

DESCRIPTION="Flycheck checker for the GNU Guile Scheme implementation"
HOMEPAGE="https://github.com/flatwhatson/flycheck-guile/"
SRC_URI="https://github.com/flatwhatson/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
REQUIRED_USE="${GUILE_REQUIRED_USE}"

BDEPEND="
	app-emacs/flycheck
	app-emacs/geiser-guile
"
RDEPEND="
	${BDEPEND}
	${GUILE_DEPS}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|\"guild\"|\"${GUILD}\"|" -i "${PN}.el" || die
}

src_install() {
	elisp_src_install
}
