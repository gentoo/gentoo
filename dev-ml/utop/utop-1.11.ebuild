# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
inherit oasis elisp-common

DESCRIPTION="A new toplevel for OCaml with completion and colorization"
HOMEPAGE="http://github.com/diml/utop"
SRC_URI="http://github.com/diml/utop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs"

DEPEND=">=dev-ml/lwt-2.4.0:=[react]
	>=dev-ml/lambda-term-1.2:=
	>=dev-ml/zed-1.2:=
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

DOCS=( "CHANGES.md" "README.md" )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i "s/(\"utop.el.*)//" setup.ml
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
