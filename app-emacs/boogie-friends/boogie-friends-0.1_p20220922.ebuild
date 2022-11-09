# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=8d1bafab5dffc3c63324b5306503943e67497ddc

inherit elisp

DESCRIPTION="Emacs tools for interacting with Boogie, Dafny and Z3 (SMT2)"
HOMEPAGE="https://github.com/boogie-org/boogie-friends/"
SRC_URI="https://github.com/boogie-org/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${H}/emacs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # broken tests - no "tests.dfy" file

RDEPEND="
	app-emacs/company-mode
	app-emacs/dash
	app-emacs/flycheck
	app-emacs/yasnippet
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-flycheck-dfy-exe.patch
	"${FILESDIR}"/${PN}-paths.patch
)

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
