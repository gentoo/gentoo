# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common

DESCRIPTION="Model checker for verifying properties of array-based systems"
HOMEPAGE="https://cubicle.lri.fr/
	https://github.com/cubicle-model-checker/cubicle/"
SRC_URI="https://github.com/cubicle-model-checker/${PN}/archive/${PV}.tar.gz
	 -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="emacs examples"

RDEPEND="
	>=dev-lang/ocaml-4.09.0:=[ocamlopt]
	dev-ml/num:=
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-ml/findlib
	sys-apps/gawk
"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-which.patch" )

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	eautoreconf

	# Makefile checks if "configure.in" exists,
	#   it is needed by the ".depend" target.
	ln -s configure.ac configure.in || die
}

src_configure() {
	econf --without-z3  # Needs Z3 Ocaml bindings, not yet packaged.
}

src_compile() {
	default

	if use emacs ; then
	   elisp-compile emacs/*.el
	fi
}

src_install() {
	# OCaml generates textrels on 32-bit arches
	if use x86 ; then
		export QA_TEXTRELS='.*'
	fi
	default

	doman doc/${PN}.1

	if use emacs ; then
	   elisp-install ${PN} emacs/*.el{,c}
	   elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	use examples && dodoc -r examples
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
