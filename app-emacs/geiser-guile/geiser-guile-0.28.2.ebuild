# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Guile's implementation of the Geiser protocols"
HOMEPAGE="https://gitlab.com/emacs-geiser/guile/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/emacs-geiser/guile.git"
else
	SRC_URI="https://gitlab.com/emacs-geiser/guile/-/archive/${PV}/guile-${PV}.tar.bz2
		-> ${P}.tar.bz2"
	S="${WORKDIR}/guile-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="
	app-emacs/geiser
"
RDEPEND="
	${BDEPEND}
	dev-scheme/guile
"

PATCHES=( "${FILESDIR}/${PN}-guile-scheme-src-dir.patch" )

DOCS=( readme.org )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i "${PN}.el" || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r src
}
