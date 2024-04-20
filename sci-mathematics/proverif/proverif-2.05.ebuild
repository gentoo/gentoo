# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo elisp-common findlib

DESCRIPTION="Cryptographic protocol verifier in the formal model"
HOMEPAGE="https://bblanche.gitlabpages.inria.fr/proverif/
	https://gitlab.inria.fr/bblanche/proverif/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.inria.fr/bblanche/${PN}.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://bblanche.gitlabpages.inria.fr/proverif/${PN}${PV}.tar.gz"
	S="${WORKDIR}/${PN}${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="emacs"

RDEPEND="
	dev-lang/ocaml:=[ocamlopt]
	emacs? ( >=app-editors/emacs-25:* )
"
DEPEND="
	${RDEPEND}
"

DOCS=( CHANGES README )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	edob sh ./build -nointeract

	if use emacs ; then
		cd "${S}/emacs" || die

		elisp-compile *.el
	fi
}

src_test() {
	edob sh ./test
}

src_install() {
	findlib_src_preinst

	exeinto /usr/bin
	doexe proverif
	doexe proveriftotex

	if use emacs ; then
		elisp-install "${PN}" "${S}/emacs"/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	einstalldocs
}
