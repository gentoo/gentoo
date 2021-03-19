# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: vim-plugin, although it's not clear how to make it work here
inherit elisp-common dune

DESCRIPTION="Context sensitive completion for OCaml in Vim and Emacs"
HOMEPAGE="https://github.com/ocaml/merlin"
SRC_URI="https://github.com/ocaml/merlin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs +ocamlopt"

RDEPEND="
	app-emacs/auto-complete
	app-emacs/company-mode
	dev-ml/csexp:=
	dev-ml/yojson:=
	>=dev-lang/ocaml-4.09:=
	<dev-lang/ocaml-4.12:=
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# Handle installation via the eclass
	rm emacs/dune || die
}

src_compile() {
	dune_src_compile

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
