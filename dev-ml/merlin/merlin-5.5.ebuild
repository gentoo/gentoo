# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: vim-plugin, although it's not clear how to make it work here
inherit elisp-common dune edo

DESCRIPTION="Context sensitive completion for OCaml in Vim and Emacs"
HOMEPAGE="https://github.com/ocaml/merlin/"
SRC_URI="https://github.com/ocaml/${PN}/releases/download/v${PV}-503/${P}-503.tbz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs +ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-5.3.0 <dev-lang/ocaml-5.4.0
	dev-ml/csexp:=
	dev-ml/yojson:=
	emacs? (
		>=app-editors/emacs-23.1:*
		app-emacs/auto-complete
		app-emacs/company-mode
	)
"
DEPEND="
	${RDEPEND}
"
# NOTICE: Block dev-ml/seq (which is a back-port of code to ocaml <4.07)
# because it breaks merlin builds.
# https://github.com/ocaml/merlin/issues/1500
BDEPEND="
	dev-ml/findlib
	test? (
		app-misc/jq
		dev-ml/alcotest
		dev-ml/ppxlib
	)
"

SITEFILE="50${PN}-gentoo.el"

DUNE_PKG_NAMES_OTHER=(
	dot-merlin-reader
	ocaml-index
	merlin-lib
)

src_unpack() {
	default

	if has_version "=dev-lang/ocaml-5.3*" ; then
		edo mv "${P}-503" "${S}"
	else
		die "The installed version of OCaml is not yet supported"
	fi
}

src_prepare() {
	default

	# Handle ELisp installation via the Emacs Eclass.
	rm emacs/dune || die

	# This test runs only inside a git repo,
	# it is not included in merlin release for ocaml 4.12.
	if [[ -f tests/test-dirs/occurrences/issue1404.t ]] ; then
		rm tests/test-dirs/occurrences/issue1404.t || die
	fi
	rm -r tests/test-dirs/locate/context-detection/cd-mod_constr.t || die

	# Remove seq references from dune build files.
	sed -i 's|seq||g' src/frontend/ocamlmerlin/dune || die

	# Remove Menhir requirement.
	# > MenhirLib.StaticVersion.require_20201216
	sed -i src/ocaml/preprocess/parser_raw.ml \
		-e "s|MenhirLib.StaticVersion.require_.*|()|g" \
		|| die
}

src_compile() {
	# This is a minimal compilation set to avoid the "menhir" dependency.
	# See the readme: https://github.com/ocaml/merlin/blob/main/README.md
	dune-compile "${DUNE_PKG_NAMES_OTHER[@]}" "${PN}"

	if use emacs ; then
		# iedit isn't packaged yet
		rm emacs/merlin-iedit.el || die

		local -x BYTECOMPFLAGS="-L emacs"
		elisp-compile ./emacs/*.el
	fi
}

src_test() {
	dune-test "${DUNE_PKG_NAMES_OTHER[@]}"

	# Dune test dance:
	# Testing not all packages removes some needed files for the install step.
	# We have to compile again, luckily this time most of the build is cached.
	dune-compile "${DUNE_PKG_NAMES_OTHER[@]}" "${PN}"
}

src_install() {
	dune_src_install

	if use emacs ; then
		elisp-install "${PN}" ./emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
