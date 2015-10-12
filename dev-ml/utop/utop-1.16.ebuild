# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
inherit oasis elisp-common

DESCRIPTION="A new toplevel for OCaml with completion and colorization"
HOMEPAGE="https://github.com/diml/utop"
SRC_URI="https://github.com/diml/utop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="camlp4 emacs"

DEPEND=">=dev-ml/lwt-2.4.0:=[react]
	>=dev-ml/lambda-term-1.2:=
	>=dev-ml/zed-1.2:=
	>=dev-ml/cppo-1.0.1:=
	emacs? ( virtual/emacs )
	camlp4? ( || ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 ) )"
RDEPEND="${DEPEND}"

DOCS=( "CHANGES.md" "README.md" )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i "s/(\"utop.el.*)//" setup.ml
}

src_configure() {
	oasis_configure_opts="$(use_enable camlp4)" \
		oasis_src_configure
}
src_compile() {
	oasis_src_compile
	if use emacs; then
		elisp-compile src/top/*.el
	fi
}

src_install() {
	oasis_src_install
	if use emacs; then
		elisp-install "${PN}" src/top/*.el src/top/*.elc || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
