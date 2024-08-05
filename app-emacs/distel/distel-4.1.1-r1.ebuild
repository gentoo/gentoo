# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Distributed Emacs Lisp for Erlang"
HOMEPAGE="https://massemanet.github.io/distel/
	https://www.emacswiki.org/emacs/DistributedEmacsLisp"
SRC_URI="https://github.com/massemanet/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

# "New BSD License" according to https://code.google.com/p/distel/
# "MIT" according to https://github.com/massemanet/distel
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="|| (
	app-emacs/erlang-mode
	dev-lang/erlang[emacs(-)]
)"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake base info
	cd elisp || die
	elisp-compile *.el
}

src_install() {
	emake prefix="${ED}"/usr \
		ELISP_DIR="${ED}${SITELISP}/${PN}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo doc/distel.info
	dodoc AUTHORS ChangeLog NEWS README*
	use doc && dodoc doc/gorrie02distel.pdf
	docinto html
	dodoc doc/distel/*.html
}
