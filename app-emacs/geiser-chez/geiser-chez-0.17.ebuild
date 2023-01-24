# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Chez Scheme's implementation of the Geiser protocols"
HOMEPAGE="https://gitlab.com/emacs-geiser/chez/"
SRC_URI="https://gitlab.com/emacs-geiser/chez/-/archive/${PV}/chez-${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/chez-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="app-emacs/geiser"
RDEPEND="
	${BDEPEND}
	dev-scheme/chez
"

DOCS=( readme.org )
PATCHES=(
	"${FILESDIR}"/${PN}-chez-scheme-binary.patch
	"${FILESDIR}"/${PN}-chez-scheme-src-dir.patch
)
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i ${PN}.el || die
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r src
}
