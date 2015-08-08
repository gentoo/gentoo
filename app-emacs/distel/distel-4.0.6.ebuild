# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Distributed Emacs Lisp for Erlang"
HOMEPAGE="http://code.google.com/p/distel/
	http://www.emacswiki.org/emacs/DistributedEmacsLisp"
SRC_URI="https://github.com/massemanet/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

# "New BSD License" according to http://code.google.com/p/distel/
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-lang/erlang-11.2.5[emacs]"
RDEPEND="${DEPEND}"

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
	dohtml doc/distel/*.html
	dodoc AUTHORS ChangeLog NEWS README*
	use doc && dodoc doc/gorrie02distel.pdf
}
