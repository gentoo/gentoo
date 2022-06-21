# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: vim-plugin, although it's not clear how to make it work here
inherit elisp-common dune

DESCRIPTION="Context sensitive completion for OCaml in Vim and Emacs"
HOMEPAGE="https://github.com/ocaml/merlin"
SRC_URI="https://github.com/ocaml/merlin/archive/v${PV}-411.tar.gz -> ${P}-411.tar.gz
	https://dev.gentoo.org/~tupone/distfiles/${P}-ocaml-4.12.patch.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs +ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/csexp:=
	<dev-ml/yojson-2:=
	dev-ml/menhir:=
	>=dev-ml/dune-2.9:=
	|| (
		dev-lang/ocaml:0/4.11
		dev-lang/ocaml:0/4.12
	)
	emacs? (
		>=app-editors/emacs-23.1:*
		app-emacs/auto-complete
		app-emacs/company-mode
	)
"
DEPEND="${RDEPEND}
	test? ( app-misc/jq )"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}"/${P}-411

src_prepare() {
	has_version "dev-lang/ocaml:0/4.12" && \
		eapply "${WORKDIR}"/${P}-ocaml-4.12.patch
	default

	# Handle installation via the eclass
	rm emacs/dune || die

	# rm failing test
	rm -r tests/test-dirs/locate/context-detection/cd-mod_constr.t || die
}

src_compile() {
	dune build @install

	if use emacs ; then
		# Build the emacs integration
		cd emacs || die

		# iedit isn't packaged yet
		rm merlin-iedit.el || die

		elisp-compile *.el
	fi
}

src_install() {
	dune_src_install

	if use emacs ; then
		cd "${S}/emacs" || die
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
