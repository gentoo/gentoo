# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=1e3b6a8aee9fa7c113468838c5b647080caf3703

inherit elisp

DESCRIPTION="Emacs tools for interacting with Boogie, Dafny and Z3 (SMT2)"
HOMEPAGE="https://github.com/boogie-org/boogie-friends/"
SRC_URI="https://github.com/boogie-org/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${H}/emacs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # cask and dafny are needed for tests

RDEPEND="
	app-emacs/company-mode
	app-emacs/dash
	app-emacs/flycheck
	app-emacs/yasnippet
"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-paths.patch )

ELISP_REMOVE="boogie-friends-pkg.el"
SITEFILE="50${PN}-gentoo.el"

DOCS=( ../README.md pictures )

src_prepare() {
	elisp_src_prepare

	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" ./boogie-friends.el || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r etc
}
