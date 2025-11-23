# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature

DESCRIPTION="Project management for Emacs package development"
HOMEPAGE="https://github.com/cask/cask/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cask/${PN}"
else
	SRC_URI="https://github.com/cask/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Most tests fail.

RDEPEND="
	app-emacs/ansi
	app-emacs/commander
	app-emacs/epl
	app-emacs/f
	app-emacs/package-build
	app-emacs/s
	app-emacs/shut-up
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/cask-0.9.0-bin-launcher-fix.patch"
	"${FILESDIR}/cask-0.9.0-home-dir.patch"
	"${FILESDIR}/cask-no-bootstrap.patch"
)
ELISP_REMOVE="
	${PN}-bootstrap.el
"

DOCS=( README.org cask_small.png )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITELISP@|${EPREFIX}${SITELISP}/${PN}|" -i "./bin/${PN}" || die
}

src_install() {
	elisp_src_install

	exeinto /usr/bin
	doexe "./bin/${PN}"
}

pkg_postinst() {
	elisp_pkg_postinst
	optfeature "using ELPA archives via SSL" \
		"net-libs/gnutls[tools] app-editors/emacs[ssl]"
}
