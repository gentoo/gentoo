# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

COMMIT="39bacece3b6a3ee5169b4b76751cf73aaccaa7a9"

inherit elisp

DESCRIPTION="Emacs tools for interacting with Boogie, Dafny and Z3 (SMT2)"
HOMEPAGE="https://github.com/boogie-org/boogie-friends/"

SRC_URI="https://github.com/boogie-org/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.snapshot.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}/emacs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # broken tests - no "tests.dfy" file

RDEPEND="
	>=app-emacs/company-mode-0.8.12
	>=app-emacs/dash-2.10.0
	>=app-emacs/yasnippet-0.9.0.1
	app-emacs/flycheck
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/boogie-friends-flycheck-dfy-exe.patch"
	"${FILESDIR}/boogie-friends-paths.patch"
)
DOCS=( ../README.md pictures )
ELISP_REMOVE="Makefile"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" ./boogie-friends.el || die
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins -r etc
}
