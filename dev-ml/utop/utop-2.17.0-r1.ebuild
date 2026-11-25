# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune elisp-common

DESCRIPTION="Universal toplevel for OCaml"
HOMEPAGE="https://github.com/ocaml-community/utop"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml-community/${PN}"
else
	SRC_URI="https://github.com/ocaml-community/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="emacs +ocamlopt test"
RESTRICT="!test? ( test )"

ELISP_DEPEND="
	emacs? (
		>=app-editors/emacs-24:*
		>=app-emacs/tuareg-mode-2.2.0
	)
"
DEPEND="
	dev-ml/lambda-term:=[ocamlopt?]
	dev-ml/logs:=[ocamlopt?]
	dev-ml/lwt:=[ocamlopt?]
	dev-ml/react:=
	dev-ml/xdg:=[ocamlopt?]
	dev-ml/zed:=[ocamlopt?]
"
RDEPEND="
	${DEPEND}
	${ELISP_DEPEND}
"
BDEPEND="
	dev-ml/cppo
	dev-ml/findlib
	${ELISP_DEPEND}
	test? ( dev-ml/alcotest )
"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	dune_src_compile

	if use emacs ; then
		local BYTECOMPFLAGS="-L src/top"
		elisp-compile src/top/*.el
	fi
}

src_install() {
	dune_src_install

	if use emacs ; then
		elisp-install ${PN} src/top/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
